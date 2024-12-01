import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/failures.dart';
import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({
    required this.localDataSource,
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = userCredential.user!;
      final user = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email!,
        name: firebaseUser.displayName ?? email.split('@')[0],
      );
      
      await localDataSource.cacheUser(user);
      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Firebase Auth Error Code: ${e.code}');
      print('Firebase Auth Error Message: ${e.message}');
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Este e-mail ainda não foi cadastrado';
          break;
        case 'wrong-password':
          message = 'Senha incorreta';
          break;
        case 'invalid-email':
          message = 'Email inválido';
          break;
        default:
          message = 'Erro ao fazer login: ${e.code}';
      }
      return Left(AuthFailure(message));
    } catch (e) {
      return Left(AuthFailure('Erro ao fazer login'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure('Falha ao fazer logout'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final user = UserModel(
          id: currentUser.uid,
          email: currentUser.email!,
          name: currentUser.displayName ?? currentUser.email!.split('@')[0],
        );
        return Right(user);
      }
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure('Falha ao obter usuário atual'));
    }
  }
}
