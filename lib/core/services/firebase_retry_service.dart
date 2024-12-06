import 'dart:async';
import 'dart:math';
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

class FirebaseRetryService {
  static const int maxRetries = 3;
  static const Duration defaultTimeout = Duration(seconds: 10);
  
  static Future<Either<Failure, T>> retryOperation<T>({
    required Future<T> Function() operation,
    Duration timeout = defaultTimeout,
    int maxAttempts = maxRetries,
  }) async {
    int retryCount = 0;
    
    Future<Either<Failure, T>> attempt() async {
      try {
        final result = await operation().timeout(
          timeout,
          onTimeout: () => throw TimeoutException('Firebase operation timed out'),
        );
        return Right(result);
      } on TimeoutException {
        return const Left(NetworkFailure('Operation timed out. Please try again.'));
      } catch (e) {
        if (e.toString().contains('PERMISSION_DENIED')) {
          return Left(AuthFailure('Access denied. Please login again.'));
        }
        if (e.toString().contains('RESOURCE_EXHAUSTED')) {
          return Left(ServerFailure('Rate limit exceeded. Please try again later.'));
        }
        if (e.toString().contains('UNAVAILABLE')) {
          return Left(NetworkFailure('Firebase service is currently unavailable.'));
        }
        return Left(ServerFailure(e.toString()));
      }
    }

    Either<Failure, T> result = await attempt();
    while (result.isLeft() && retryCount < maxAttempts) {
      // Exponential backoff
      await Future.delayed(Duration(seconds: pow(2, retryCount).toInt()));
      result = await attempt();
      retryCount++;
    }

    return result;
  }
}
