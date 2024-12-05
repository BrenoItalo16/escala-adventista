import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _database;
  final StorageService _storageService;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseDatabase database,
    required StorageService storageService,
    required AuthLocalDataSource localDataSource,
  })  : _firebaseAuth = firebaseAuth,
        _database = database,
        _storageService = storageService,
        _localDataSource = localDataSource;

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
      // Primeiro limpa os dados locais para garantir que o usuário não fique preso
      await _storageService.clearAuthState();
      await _localDataSource.clearUser();

      // Tenta fazer logout do Firebase com timeout
      await Future.any([
        _firebaseAuth.signOut(),
        Future.delayed(const Duration(seconds: 5))
            .then((_) => throw TimeoutException('Timeout ao fazer logout do Firebase')),
      ]);

      return const Right(null);
    } on TimeoutException catch (e) {
      // Se houver timeout, ainda retorna sucesso pois os dados locais foram limpos
      debugPrint('Timeout durante logout: $e');
      return const Right(null);
    } catch (e) {
      debugPrint('Erro durante logout: $e');
      // Mesmo com erro, os dados locais já foram limpos
      return const Right(null);
    }
  }

  @override
  Future<Either<AuthFailure, UserModel?>> getCurrentUser() async {
    try {
      final isAuthenticated = _storageService.getAuthState() ?? false;
      if (!isAuthenticated) {
        return const Right(null);
      }

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        await _storageService.clearAuthState();
        return const Right(null);
      }

      final userDoc =
          await _database.ref().child('users/${currentUser.uid}').get();

      if (!userDoc.exists) {
        await _storageService.clearAuthState();
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
