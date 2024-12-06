import 'package:firebase_database/firebase_database.dart';
import '../config/firebase_config.dart';

abstract class IFirebaseDatabaseService {
  DatabaseReference getReference();
}

class FirebaseDatabaseService implements IFirebaseDatabaseService {
  final FirebaseDatabase _database;

  FirebaseDatabaseService._({FirebaseDatabase? database}) 
    : _database = database ?? FirebaseDatabase.instance;

  static FirebaseDatabaseService? _instance;

  static FirebaseDatabaseService get instance {
    _instance ??= FirebaseDatabaseService._();
    return _instance!;
  }

  @override
  DatabaseReference getReference() {
    return _database.refFromURL(FirebaseConfig.databaseUrl);
  }
}
