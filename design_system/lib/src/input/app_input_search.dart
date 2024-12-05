import 'dart:async';

import 'package:escala_adventista/features/home/presentation/bloc/song_search_bloc.dart';
import 'package:escala_adventista/models/song_model.dart';
import 'package:escala_adventista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import '../../design_system.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppInputSearch extends StatefulWidget {
  const AppInputSearch({super.key});

  @override
  State<AppInputSearch> createState() => _AppInputSearchState();
}

class _AppInputSearchState extends State<AppInputSearch> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _currentPage = 1;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore) {
      _loadMoreSongs();
    }
  }

  void _loadMoreSongs() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });

      context.read<SongSearchBloc>().add(
            SearchSongEvent(
              query: _searchController.text,
              page: _currentPage,
            ),
          );
    }
  }

  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _currentPage = 1;
      });
      context.read<SongSearchBloc>().add(
            SearchSongEvent(
              query: _searchController.text,
              page: _currentPage,
            ),
          );
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Buscar', style: AppFont.labelM12Bold),
        const SizedBox(height: 4),
        TextFormField(
          controller: _searchController,
          style: AppFont.bodyL16Regular.copyWith(
            color: TxtColors.primary,
          ),
          decoration: InputDecoration(
            suffixIcon: Icon(UIcons.regularRounded.search),
            hintText: 'Buscar música ou artista',
            hintStyle: AppFont.bodyL16Regular.copyWith(
              color: TxtColors.hint,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.stroked),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.focused),
            ),
            filled: true,
            fillColor: AppColors.inputBg,
          ),
          keyboardType: TextInputType.text,
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocConsumer<SongSearchBloc, SongSearchState>(
            listener: (context, state) {
              if (state is SongSearchSuccess && _isLoadingMore) {
                setState(() {
                  _isLoadingMore = false;
                });
              } else if (state is SongSaved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Música favoritada com sucesso!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state is SongSearchError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is SongSearchLoading && _currentPage == 1) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SongSearchError && _currentPage == 1) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: AppFont.bodyL16Regular,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _performSearch,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                );
              } else if (state is SongSearchSuccess) {
                final songs = state.songs;
                if (songs.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma música encontrada',
                      style: AppFont.bodyL16Regular,
                    ),
                  );
                }

                final docs =
                    (songs['response']?['docs'] as List<dynamic>?) ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: docs.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == docs.length) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final song = docs[index] as Song;
                    return ListTile(
                      onTap: () {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          context.read<SongSearchBloc>().add(
                                SaveFavoriteSongEvent(
                                  song: song,
                                  userId: authState.user.id,
                                ),
                              );
                        }
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: song.coverUrl.isEmpty
                            ? Container(
                                width: 56,
                                height: 56,
                                color: Colors.grey[300],
                                child: const Icon(Icons.music_note),
                              )
                            : Image.network(
                                song.coverUrl,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.music_note),
                                  );
                                },
                              ),
                      ),
                      title: Text(
                        song.name,
                        style: AppFont.bodyL16Regular,
                      ),
                      subtitle: Text(
                        song.artist.name,
                        style: AppFont.bodyM14Regular,
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
