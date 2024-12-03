part of 'song_search_bloc.dart';

abstract class SongSearchEvent extends Equatable {
  const SongSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchSongEvent extends SongSearchEvent {
  final String query;
  final int page;

  const SearchSongEvent({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object> get props => [query, page];
}

class SaveFavoriteSongEvent extends SongSearchEvent {
  final Song song;
  final String userId;

  const SaveFavoriteSongEvent({
    required this.song,
    required this.userId,
  });

  @override
  List<Object> get props => [song, userId];
}
