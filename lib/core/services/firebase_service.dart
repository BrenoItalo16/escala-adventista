import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../firebase_options.dart';

abstract class IFirebaseService {
  Future<void> initialize();
  DatabaseReference getDatabaseReference();
}

class FirebaseService implements IFirebaseService {
  static FirebaseService? _instance;
  late final FirebaseDatabase _database;
  bool _isInitialized = false;

  FirebaseService._();

  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final databaseUrl = dotenv.env['FIREBASE_DATABASE_URL'];
    if (databaseUrl == null || databaseUrl.isEmpty) {
      throw Exception('FIREBASE_DATABASE_URL not found in .env file');
    }

    FirebaseDatabase.instance.databaseURL = databaseUrl;
    _database = FirebaseDatabase.instance;
    _isInitialized = true;
  }

  @override
  DatabaseReference getDatabaseReference() {
    if (!_isInitialized) {
      throw Exception('FirebaseService must be initialized before use');
    }
    return _database.ref();
  }
}
