import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IFirebaseRemoteDataSource {
  DatabaseReference getReference();
}

class FirebaseRemoteDataSource implements IFirebaseRemoteDataSource {
  FirebaseRemoteDataSource._() {
    final databaseUrl = dotenv.env['FIREBASE_DATABASE_URL'];
    if (databaseUrl != null && databaseUrl.isNotEmpty) {
      FirebaseDatabase.instance.databaseURL = databaseUrl;
    }
  }
  
  static FirebaseRemoteDataSource? _instance;

  static FirebaseRemoteDataSource get instance {
    _instance ??= FirebaseRemoteDataSource._();
    return _instance!;
  }

  @override
  DatabaseReference getReference() {
    return FirebaseDatabase.instance.ref();
  }
}
