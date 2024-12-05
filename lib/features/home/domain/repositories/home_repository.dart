import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  /// Obtém os dados iniciais da home
  /// 
  /// Retorna [Either] com [Failure] em caso de erro ou [void] em caso de sucesso
  Future<Either<Failure, void>> getHomeData();
}
