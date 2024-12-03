part of 'song_search_bloc.dart';

abstract class SongSearchState extends Equatable {
  const SongSearchState();
  
  @override
  List<Object> get props => [];
}

class SongSearchInitial extends SongSearchState {}

class SongSearchLoading extends SongSearchState {}

class SongSearchSuccess extends SongSearchState {
  final Map<String, dynamic> songs;

  const SongSearchSuccess(this.songs);

  @override
  List<Object> get props => [songs];
}

class SongSearchError extends SongSearchState {
  final String message;

  const SongSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SongSaved extends SongSearchState {}
