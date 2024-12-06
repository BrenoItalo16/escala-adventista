import 'package:dartz/dartz.dart';
import '../../error/failures.dart';

abstract class BaseRepository<T> {
  Future<Either<Failure, T>> get(String id);
  Future<Either<Failure, List<T>>> getAll();
  Future<Either<Failure, void>> save(T item);
  Future<Either<Failure, void>> delete(String id);
  Future<Either<Failure, void>> update(T item);
}
