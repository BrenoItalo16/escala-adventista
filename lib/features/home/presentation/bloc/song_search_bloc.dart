import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../services/spotify_service.dart';
import '../../../../models/song_model.dart';
import '../../domain/repositories/favorite_songs_repository.dart';
import '../../domain/entities/favorite_song.dart';

part 'song_search_event.dart';
part 'song_search_state.dart';

class SongSearchBloc extends Bloc<SongSearchEvent, SongSearchState> {
  final SpotifyService _spotifyService;
  final FavoriteSongsRepository _favoriteSongsRepository;
  Map<String, dynamic> _currentSongs = {};

  SongSearchBloc({
    required SpotifyService spotifyService,
    required FavoriteSongsRepository favoriteSongsRepository,
  })  : _spotifyService = spotifyService,
        _favoriteSongsRepository = favoriteSongsRepository,
        super(SongSearchInitial()) {
    on<SearchSongEvent>(_onSearchSong);
    on<SaveFavoriteSongEvent>(_onSaveFavoriteSong);
  }

  Future<void> _onSearchSong(
    SearchSongEvent event,
    Emitter<SongSearchState> emit,
  ) async {
    try {
      if (event.page == 1) {
        emit(SongSearchLoading());
        _currentSongs = {};
      }

      final result = await _spotifyService.searchSong(
        event.query,
        event.page.toString(),
      );

      if (event.page == 1 && (result['response']?['numFound'] ?? 0) == 0) {
        emit(const SongSearchError('Nenhuma música encontrada'));
        return;
      }

      if (event.page > 1) {
        // Merge new results with existing ones
        final existingDocs =
            _currentSongs['response']?['docs'] as List<dynamic>? ?? [];
        final newDocs = result['response']?['docs'] as List<dynamic>? ?? [];
        result['response']['docs'] = [...existingDocs, ...newDocs];
      }

      // Parse songs properly
      final docs = result['response']?['docs'] as List<dynamic>? ?? [];
      final songs = docs.map((doc) => Song.fromJson(doc)).toList();
      
      _currentSongs = {
        'response': {
          'numFound': result['response']?['numFound'] ?? 0,
          'docs': songs,
        }
      };

      emit(SongSearchSuccess(_currentSongs));
    } catch (e) {
      if (event.page == 1) {
        emit(SongSearchError(e.toString()));
      }
    }
  }

  Future<void> _onSaveFavoriteSong(
    SaveFavoriteSongEvent event,
    Emitter<SongSearchState> emit,
  ) async {
    try {
      final favoriteSong = FavoriteSong(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.song.name,
        artist: event.song.artist.name,
        url: event.song.url,
        coverUrl: event.song.coverUrl,
        userId: event.userId,
        createdAt: DateTime.now(),
      );

      final result =
          await _favoriteSongsRepository.saveFavoriteSong(favoriteSong);
      result.fold(
        (failure) => emit(SongSearchError(failure.message)),
        (_) {
          emit(SongSaved());
          emit(SongSearchSuccess(_currentSongs));
        },
      );
    } catch (e) {
      emit(SongSearchError('Erro ao salvar música favorita: $e'));
    }
  }
}
