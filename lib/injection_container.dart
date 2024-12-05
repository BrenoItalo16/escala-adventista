import 'package:escala_adventista/features/home/data/repositories/favorite_songs_repository_impl.dart';
import 'package:escala_adventista/features/home/domain/repositories/favorite_songs_repository.dart';
import 'package:escala_adventista/features/home/presentation/bloc/song_search_bloc.dart';
import 'package:escala_adventista/services/spotify_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'core/services/storage_service.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/domain/usecases/get_home_data_usecase.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Reset GetIt instance if it's already initialized
  if (sl.isRegistered<AuthBloc>()) {
    await sl.reset();
  }

  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      signupUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => StorageService(sharedPreferences));

  // Firebase
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseDatabase = FirebaseDatabase.instance;

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth: firebaseAuth,
      database: firebaseDatabase,
      storageService: sl(),
      localDataSource: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(() => SpotifyService());

  // Repositories
  sl.registerLazySingleton<FavoriteSongsRepository>(
    () => FavoriteSongsRepositoryImpl(
      database: firebaseDatabase,
      auth: firebaseAuth,
    ),
  );

  // Home
  sl.registerFactory(() => HomeBloc(getHomeData: sl()));
  sl.registerLazySingleton(() => GetHomeDataUseCase(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());

  // Blocs
  sl.registerFactory(
    () => SongSearchBloc(
      spotifyService: sl(),
      favoriteSongsRepository: sl(),
    ),
  );
}
