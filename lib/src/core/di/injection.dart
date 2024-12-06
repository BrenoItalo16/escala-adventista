export 'injection.dart' show getIt, init;

import 'package:get_it/get_it.dart';
import '../../services/connectivity_service.dart';
import '../../../core/data/datasources/firebase_database_datasource.dart';
import '../../../features/church/data/repositories/firebase_church_repository.dart';
import '../../../features/church/domain/repositories/church_repository.dart';
import '../../../features/church/domain/usecases/create_church.dart';
import '../../../features/church/domain/usecases/delete_church.dart';
import '../../../features/church/domain/usecases/get_church.dart';
import '../../../features/church/domain/usecases/get_churches.dart';
import '../../../features/church/domain/usecases/update_church.dart';
import '../../../features/church/domain/usecases/increment_likes.dart';
import '../../../features/church/domain/usecases/decrement_likes.dart';
import '../../../features/church/domain/usecases/increment_members.dart';
import '../../../features/church/domain/usecases/decrement_members.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Services
  getIt.registerSingleton<ConnectivityService>(ConnectivityService());

  // Core
  getIt.registerLazySingleton<IFirebaseDatabaseDatasource>(
    () => FirebaseDatabaseDatasource.instance,
  );

  // Initialize Firebase
  final firebaseDataSource = getIt<IFirebaseDatabaseDatasource>();
  await firebaseDataSource.initialize();

  // Church Feature
  // Repository
  getIt.registerLazySingleton<ChurchRepository>(
    () => FirebaseChurchRepository(
      firebaseDataSource: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetChurches(getIt()));
  getIt.registerLazySingleton(() => GetChurch(getIt()));
  getIt.registerLazySingleton(() => CreateChurch(getIt()));
  getIt.registerLazySingleton(() => UpdateChurch(getIt()));
  getIt.registerLazySingleton(() => DeleteChurch(getIt()));
  getIt.registerLazySingleton(() => IncrementLikes(getIt()));
  getIt.registerLazySingleton(() => DecrementLikes(getIt()));
  getIt.registerLazySingleton(() => IncrementMembers(getIt()));
  getIt.registerLazySingleton(() => DecrementMembers(getIt()));
}
