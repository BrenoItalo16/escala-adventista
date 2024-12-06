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
  // Aguarda o Firebase Database Datasource estar pronto
  if (!getIt.isRegistered<IFirebaseDatabaseDatasource>()) {
    throw Exception('IFirebaseDatabaseDatasource must be registered before initializing Church feature');
  }

  // Repository
  if (!getIt.isRegistered<ChurchRepository>()) {
    getIt.registerLazySingleton<ChurchRepository>(
      () => FirebaseChurchRepository(
        firebaseDataSource: getIt<IFirebaseDatabaseDatasource>(),
      ),
    );
  }

  // Use Cases
  if (!getIt.isRegistered<CreateChurch>()) {
    getIt.registerLazySingleton(() => CreateChurch(getIt()));
  }
  if (!getIt.isRegistered<DeleteChurch>()) {
    getIt.registerLazySingleton(() => DeleteChurch(getIt()));
  }
  if (!getIt.isRegistered<GetChurchById>()) {
    getIt.registerLazySingleton(() => GetChurchById(getIt()));
  }
  if (!getIt.isRegistered<GetChurches>()) {
    getIt.registerLazySingleton(() => GetChurches(getIt()));
  }
  if (!getIt.isRegistered<GetChurchesByOwnerId>()) {
    getIt.registerLazySingleton(() => GetChurchesByOwnerId(getIt()));
  }
  if (!getIt.isRegistered<UpdateChurch>()) {
    getIt.registerLazySingleton(() => UpdateChurch(getIt()));
  }
  if (!getIt.isRegistered<IncrementLikes>()) {
    getIt.registerLazySingleton(() => IncrementLikes(getIt()));
  }
  if (!getIt.isRegistered<DecrementLikes>()) {
    getIt.registerLazySingleton(() => DecrementLikes(getIt()));
  }
  if (!getIt.isRegistered<IncrementMembers>()) {
    getIt.registerLazySingleton(() => IncrementMembers(getIt()));
  }
  if (!getIt.isRegistered<DecrementMembers>()) {
    getIt.registerLazySingleton(() => DecrementMembers(getIt()));
  }
}
