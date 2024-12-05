import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<Either<Failure, void>> getHomeData() async {
    try {
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Erro ao obter dados da home: $e'));
    }
  }
}
