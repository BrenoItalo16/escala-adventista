import 'package:get_it/get_it.dart';
import '../../../core/data/datasources/firebase_database_datasource.dart';
import '../data/repositories/firebase_church_repository.dart';
import '../domain/repositories/church_repository.dart';
import '../domain/usecases/create_church.dart';
import '../domain/usecases/delete_church.dart';
import '../domain/usecases/get_church_by_id.dart';
import '../domain/usecases/get_churches.dart';
import '../domain/usecases/get_churches_by_owner_id.dart';
import '../domain/usecases/increment_likes.dart';
import '../domain/usecases/decrement_likes.dart';
import '../domain/usecases/increment_members.dart';
import '../domain/usecases/decrement_members.dart';
import '../domain/usecases/update_church.dart';

final getIt = GetIt.instance;

Future<void> initChurch() async {
  // Repository
  getIt.registerLazySingleton<ChurchRepository>(
    () => FirebaseChurchRepository(
      firebaseDataSource: getIt<IFirebaseDatabaseDatasource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => CreateChurch(getIt()));
  getIt.registerLazySingleton(() => DeleteChurch(getIt()));
  getIt.registerLazySingleton(() => GetChurchById(getIt()));
  getIt.registerLazySingleton(() => GetChurches(getIt()));
  getIt.registerLazySingleton(() => GetChurchesByOwnerId(getIt()));
  getIt.registerLazySingleton(() => UpdateChurch(getIt()));
  getIt.registerLazySingleton(() => IncrementLikes(getIt()));
  getIt.registerLazySingleton(() => DecrementLikes(getIt()));
  getIt.registerLazySingleton(() => IncrementMembers(getIt()));
  getIt.registerLazySingleton(() => DecrementMembers(getIt()));
}
