import 'package:get_it/get_it.dart';

import '../data/repositories/home_repository_impl.dart';
import '../data/repositories/favorite_songs_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/repositories/favorite_songs_repository.dart';
import '../domain/usecases/get_home_data_usecase.dart';
import '../presentation/bloc/home_bloc.dart';
import '../presentation/bloc/song_search_bloc.dart';
import '../../../services/spotify_service.dart';

final sl = GetIt.instance;

Future<void> initHomeFeature() async {
  // Blocs
  sl.registerFactory(
    () => HomeBloc(
      getHomeData: sl(),
    ),
  );

  sl.registerFactory(
    () => SongSearchBloc(
      spotifyService: sl(),
      favoriteSongsRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHomeDataUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(),
  );

  sl.registerLazySingleton<FavoriteSongsRepository>(
    () => FavoriteSongsRepositoryImpl(
      database: sl(),
      auth: sl(),
    ),
  );

  // Services
  if (!sl.isRegistered<SpotifyService>()) {
    sl.registerLazySingleton(() => SpotifyService());
  }
}
