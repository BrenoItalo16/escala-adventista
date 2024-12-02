import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  //! Login
  Future<Either<AuthFailure, User>> login({
    required String email,
    required String password,
  });
  Future<Either<AuthFailure, void>> logout();
  Future<Either<AuthFailure, User?>> getCurrentUser();

  //! Signup
  Future<Either<AuthFailure, User>> signup({
    required String name,
    required String email,
    required String password,
  });
}
