import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  //! Login
  Future<Either<AuthFailure, UserEntity>> login({
    required String email,
    required String password,
  });
  Future<Either<AuthFailure, void>> logout();
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser();

  //! Signup
  Future<Either<AuthFailure, UserEntity>> signup({
    required String name,
    required String email,
    required String password,
  });

  //! Auth Status
  Future<Either<AuthFailure, bool>> checkAuthStatus();

  //! User Details
  Future<Either<AuthFailure, UserEntity>> getCurrentUserDetails();
}
