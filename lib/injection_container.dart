import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'core/network/network_info.dart';
import 'core/services/storage_service.dart';
import 'core/data/datasources/firebase_database_datasource.dart';

import 'features/auth/di/auth_injection.dart' as auth_di;
import 'features/splash/di/splash_injection.dart' as splash_di;
import 'features/church/di/church_injection_container.dart' as church_di;

// Global singleton instance
final sl = GetIt.instance;

Future<void> init() async {
  // Reset GetIt instance if needed
  await sl.reset();

  // External Dependencies - Register as Singletons
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseDatabase.instance);
  sl.registerLazySingleton(() => Connectivity());

  // Wait for async dependencies to be ready
  await sl.isReady<SharedPreferences>();

  // Core Services - Register as Singletons
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  sl.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(prefs: sl()),
  );

  // Register Firebase Database Datasource as singleton instance
  final firebaseDataSource = FirebaseDatabaseDatasource.instance;
  await firebaseDataSource.initialize();
  sl.registerLazySingleton<IFirebaseDatabaseDatasource>(
    () => firebaseDataSource,
  );

  // Initialize Features in Order
  // Auth must be first as other features depend on it
  await auth_di.initAuthFeature();
  
  // Splash depends on Auth
  await splash_di.initSplashFeature();

  // Initialize Church feature
  await church_di.initChurch();
}
