import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class GetAuthStatusUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  GetAuthStatusUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final result = await repository.getCurrentUser();
    return result.fold(
      (failure) => Left(failure),
      (user) => Right(user != null),
    );
  }
}
