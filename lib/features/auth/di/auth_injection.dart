import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/network_info.dart';
import '../../../core/services/storage_service.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/signup_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initAuthFeature() async {
  // Ensure core dependencies are registered
  if (!sl.isRegistered<NetworkInfo>()) {
    throw Exception(
        'NetworkInfo must be registered before initializing Auth feature');
  }

  // Data Sources
  if (!sl.isRegistered<AuthLocalDataSource>()) {
    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: sl<SharedPreferences>(),
      ),
    );
  }

  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: sl<FirebaseAuth>(),
        storageService: sl<StorageService>(),
      ),
    );
  }

  // Repositories
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        firebaseAuth: sl(),
        database: sl(),
        storageService: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    );
  }

  // Domain Layer - Use Cases
  if (!sl.isRegistered<GetCurrentUserUseCase>()) {
    sl.registerLazySingleton(
      () => GetCurrentUserUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton(
      () => LoginUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerLazySingleton(
      () => LogoutUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<SignupUseCase>()) {
    sl.registerLazySingleton(
      () => SignupUseCase(sl<AuthRepository>()),
    );
  }

  // Presentation Layer
  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory(
      () => AuthBloc(
        loginUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
        signupUseCase: sl(),
      ),
    );
  }
}
