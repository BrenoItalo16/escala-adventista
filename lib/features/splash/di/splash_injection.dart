import 'package:get_it/get_it.dart';

import '../../../core/network/network_info.dart';
import '../../../core/services/storage_service.dart';
import '../data/repositories/splash_repository_impl.dart';
import '../domain/repositories/splash_repository.dart';
import '../domain/usecases/check_auth_status_usecase.dart';
import '../presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> initSplashFeature() async {
  // Ensure core dependencies are registered first
  if (!sl.isRegistered<NetworkInfo>()) {
    throw Exception(
        'NetworkInfo must be registered before initializing Splash feature');
  }

  if (!sl.isRegistered<StorageService>()) {
    throw Exception(
        'StorageService must be registered before initializing Splash feature');
  }

  // Repository
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(
      authService: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => CheckAuthStatusUseCase(sl<SplashRepository>()),
  );

  // BLoC
  sl.registerFactory(
    () => SplashBloc(
      checkAuthStatus: sl(),
    ),
  );
}
