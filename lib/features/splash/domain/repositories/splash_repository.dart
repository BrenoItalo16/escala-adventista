import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class SplashRepository {
  Future<Either<Failure, bool>> checkAuthStatus();
}
