import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/firebase_retry_service.dart';
import '../../domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final StorageService authService;
  final NetworkInfo networkInfo;

  SplashRepositoryImpl({
    required this.authService,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure());
      }

      return await FirebaseRetryService.retryOperation<bool>(
        operation: () async {
          final token = await authService.getToken();
          return token != null;
        },
      );
    } on ConnectivityException {
      return const Left(NetworkFailure());
    } on TimeoutException {
      return const Left(NetworkFailure('Operation timed out. Please try again.'));
    } on StorageException catch (e) {
      if (e.message.contains('permission-denied')) {
        return Left(AuthFailure('Access denied. Please login again.'));
      }
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      if (e.toString().contains('firebase') || e.toString().contains('FirebaseError')) {
        return Left(ServerFailure('Firebase error: ${e.toString()}'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
