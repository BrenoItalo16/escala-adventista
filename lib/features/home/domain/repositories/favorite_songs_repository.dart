import 'package:dartz/dartz.dart';
import '../entities/favorite_song.dart';
import '../../../../core/error/failures.dart';

abstract class FavoriteSongsRepository {
  Future<Either<Failure, List<FavoriteSong>>> getFavoriteSongs();
  Future<Either<Failure, void>> saveFavoriteSong(FavoriteSong song);
  Future<Either<Failure, void>> removeFavoriteSong(String songId);
}
