import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'dart:async';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _database;
  final StorageService _storageService;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseDatabase database,
    required StorageService storageService,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _firebaseAuth = firebaseAuth,
        _database = database,
        _storageService = storageService,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(AuthFailure('No internet connection'));
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(AuthFailure('Login failed'));
      }

      final user = userCredential.user!;
      final token = await user.getIdToken();
      if (token != null) {
        await _storageService.setToken(token);
      }

      final userDoc = await _database.ref().child('users/${user.uid}').get();
      if (!userDoc.exists) {
        return Left(AuthFailure('User data not found'));
      }

      final userDto = UserDTO.fromJson(
        Map<String, dynamic>.from(userDoc.value as Map),
      );

      await _localDataSource.cacheUser(userDto);
      return Right(userDto.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _storageService.clearToken();
      await _localDataSource.clearUserData();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Logout failed'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser() async {
    try {
      if (!await _networkInfo.isConnected) {
        final cachedUser = await _localDataSource.getLastUser();
        return Right(cachedUser?.toEntity());
      }

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        await _storageService.clearToken();
        await _localDataSource.clearUserData();
        return const Right(null);
      }

      final userDoc = await _database.ref().child('users/${user.uid}').get();
      if (!userDoc.exists) {
        await _storageService.clearToken();
        await _localDataSource.clearUserData();
        return const Right(null);
      }

      final token = await user.getIdToken();
      if (token != null) {
        await _storageService.setToken(token);
      }

      final userDto = UserDTO.fromJson(
        Map<String, dynamic>.from(userDoc.value as Map),
      );

      await _localDataSource.cacheUser(userDto);
      return Right(userDto.toEntity());
    } catch (e) {
      return Left(AuthFailure('Failed to get current user'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(AuthFailure('No internet connection'));
      }

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(AuthFailure('Signup failed'));
      }

      final user = userCredential.user!;
      await user.updateDisplayName(name);

      final userDto = UserDTO(
        id: user.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await _database.ref().child('users/${userDto.id}').set(userDto.toJson());
      await _localDataSource.cacheUser(userDto);

      final token = await user.getIdToken();
      if (token != null) {
        await _storageService.setToken(token);
      }

      return Right(userDto.toEntity());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Signup failed'));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<AuthFailure, bool>> checkAuthStatus() async {
    if (!await _networkInfo.isConnected) {
      return Left(AuthFailure('No internet connection'));
    }

    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return const Right(false);
      }

      final userDoc =
          await _database.ref().child('users/${currentUser.uid}').get();

      if (!userDoc.exists) {
        await _storageService.clearToken();
        return const Right(false);
      }

      return const Right(true);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity>> getCurrentUserDetails() async {
    if (!await _networkInfo.isConnected) {
      return Left(AuthFailure('No internet connection'));
    }

    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return Left(AuthFailure('User is not authenticated'));
      }

      final userDoc =
          await _database.ref().child('users/${currentUser.uid}').get();

      if (!userDoc.exists) {
        await _storageService.clearToken();
        return Left(AuthFailure('User not found'));
      }

      final userData = Map<String, dynamic>.from(
        userDoc.value as Map,
      );

      return Right(UserDTO.fromJson(userData).toEntity());
    } catch (e) {
      return Left(AuthFailure('Failed to get current user details'));
    }
  }
}
