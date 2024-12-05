import 'package:dartz/dartz.dart';
import 'package:escala_adventista/core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase implements UseCase<void, NoParams> {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.getHomeData();
  }
}
