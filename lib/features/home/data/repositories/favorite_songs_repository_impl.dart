import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/favorite_song.dart';
import '../../domain/repositories/favorite_songs_repository.dart';

class FavoriteSongsRepositoryImpl implements FavoriteSongsRepository {
  final FirebaseDatabase _database;
  final FirebaseAuth _auth;

  FavoriteSongsRepositoryImpl({
    required FirebaseDatabase database,
    required FirebaseAuth auth,
  })  : _database = database,
        _auth = auth;

  @override
  Future<Either<Failure, List<FavoriteSong>>> getFavoriteSongs() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return Left(const AuthFailure('Usuário não autenticado'));
      }

      final snapshot = await _database
          .ref()
          .child('favorite_songs')
          .child(userId)
          .get();

      if (!snapshot.exists) {
        return const Right([]);
      }

      final songsMap = Map<String, dynamic>.from(snapshot.value as Map);
      final songs = songsMap.entries.map((entry) {
        final songData = Map<String, dynamic>.from(entry.value as Map);
        return FavoriteSong.fromJson({...songData, 'id': entry.key});
      }).toList();

      return Right(songs);
    } catch (e) {
      return Left(ServerFailure('Erro ao buscar músicas favoritas: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveFavoriteSong(FavoriteSong song) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return Left(const AuthFailure('Usuário não autenticado'));
      }

      // Remove todas as músicas favoritas existentes
      await _database
          .ref()
          .child('favorite_songs')
          .child(userId)
          .remove();

      // Salva a nova música favorita
      final newSongRef = _database
          .ref()
          .child('favorite_songs')
          .child(userId)
          .push();

      await newSongRef.set(song.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Erro ao salvar música favorita: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteSong(String songId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return Left(const AuthFailure('Usuário não autenticado'));
      }

      await _database
          .ref()
          .child('favorite_songs')
          .child(userId)
          .child(songId)
          .remove();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Erro ao remover música favorita: $e'));
    }
  }
}
