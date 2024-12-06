import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDTO> login(String email, String password);
  Future<void> logout();
  Future<UserDTO?> getCurrentUser();
  Future<UserDTO> signup(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final StorageService storageService;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.storageService,
  });

  @override
  Future<UserDTO> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw AuthException('Login failed');
      }

      final user = userCredential.user!;
      final token = await user.getIdToken();
      
      if (token != null) {
        await storageService.setToken(token);
      }

      return UserDTO(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      await storageService.clearAuthState();
    } catch (e) {
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserDTO?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;

      final token = await user.getIdToken();
      if (token != null) {
        await storageService.setToken(token);
      }

      return UserDTO(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );
    } catch (e) {
      throw AuthException('Get current user failed: ${e.toString()}');
    }
  }

  @override
  Future<UserDTO> signup(String name, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException('Signup failed');
      }

      final user = userCredential.user!;
      await user.updateDisplayName(name);
      
      final token = await user.getIdToken();
      if (token != null) {
        await storageService.setToken(token);
      }

      return UserDTO(
        id: user.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw AuthException('Signup failed: ${e.toString()}');
    }
  }
}
