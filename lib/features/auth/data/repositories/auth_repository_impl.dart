import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _database;

  AuthRepositoryImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseDatabase database,
  })  : _firebaseAuth = firebaseAuth,
        _database = database;

  @override
  Future<Either<AuthFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(AuthFailure('Erro ao criar usuário'));
      }

      final user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await _database.ref().child('users/${user.id}').set(user.toJson());

      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return Left(AuthFailure('Este e-mail já está em uso'));
        case 'invalid-email':
          return Left(AuthFailure('E-mail inválido'));
        case 'operation-not-allowed':
          return Left(AuthFailure('Operação não permitida'));
        case 'weak-password':
          return Left(AuthFailure('A senha é muito fraca'));
        default:
          return Left(AuthFailure('Erro ao criar usuário: ${e.message}'));
      }
    } catch (e) {
      return Left(AuthFailure('Erro ao criar usuário: $e'));
    }
  }

  @override
  Future<Either<AuthFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(AuthFailure('Erro ao fazer login'));
      }

      final userDoc = await _database
          .ref()
          .child('users/${userCredential.user!.uid}')
          .get();

      if (!userDoc.exists) {
        return Left(AuthFailure('Usuário não encontrado'));
      }

      final user = UserModel.fromJson(
        Map<String, dynamic>.from(userDoc.value as Map),
      );

      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return Left(AuthFailure('Usuário não encontrado'));
        case 'wrong-password':
          return Left(AuthFailure('Senha incorreta'));
        case 'invalid-email':
          return Left(AuthFailure('E-mail inválido'));
        case 'user-disabled':
          return Left(AuthFailure('Usuário desabilitado'));
        default:
          return Left(AuthFailure('Erro ao fazer login: ${e.message}'));
      }
    } catch (e) {
      return Left(AuthFailure('Erro ao fazer login: $e'));
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Erro ao fazer logout: $e'));
    }
  }

  @override
  Future<Either<AuthFailure, UserModel?>> getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return const Right(null);
      }

      final userDoc =
          await _database.ref().child('users/${currentUser.uid}').get();

      if (!userDoc.exists) {
        return Left(AuthFailure('Usuário não encontrado'));
      }

      final user = UserModel.fromJson(
        Map<String, dynamic>.from(userDoc.value as Map),
      );

      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Erro ao obter usuário atual: $e'));
    }
  }
}
