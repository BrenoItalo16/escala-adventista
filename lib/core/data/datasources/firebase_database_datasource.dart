import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../firebase_options.dart';

abstract class IFirebaseDatabaseDatasource {
  Future<void> initialize();
  Future<DataSnapshot> get(String path);
  Future<void> set(String path, Map<String, dynamic> data);
  Future<void> update(String path, Map<String, dynamic> data);
  Future<void> remove(String path);
  DatabaseReference getReference(String path);
  Future<DataSnapshot> query(String path, {
    String? orderByChild,
    dynamic equalTo,
  });
}

class FirebaseDatabaseDatasource implements IFirebaseDatabaseDatasource {
  static final FirebaseDatabaseDatasource _instance = FirebaseDatabaseDatasource._internal();
  static FirebaseDatabaseDatasource get instance => _instance;

  FirebaseDatabaseDatasource._internal();

  late FirebaseDatabase _database;
  bool _isInitialized = false;

  void _checkInitialization() {
    if (!_isInitialized) {
      throw Exception('FirebaseDatabaseDatasource not initialized');
    }
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
  Future<DataSnapshot> get(String path) async {
    _checkInitialization();
    return await _database.ref(path).get();
  }

  @override
  Future<void> set(String path, Map<String, dynamic> data) async {
    _checkInitialization();
    await _database.ref(path).set(data);
  }

  @override
  Future<void> update(String path, Map<String, dynamic> data) async {
    _checkInitialization();
    await _database.ref(path).update(data);
  }

  @override
  Future<void> remove(String path) async {
    _checkInitialization();
    await _database.ref(path).remove();
  }

  @override
  DatabaseReference getReference(String path) {
    _checkInitialization();
    return _database.ref(path);
  }

  @override
  Future<DataSnapshot> query(String path, {
    String? orderByChild,
    dynamic equalTo,
  }) async {
    _checkInitialization();
    Query query = _database.ref(path);
    
    if (orderByChild != null) {
      query = query.orderByChild(orderByChild);
    }
    
    if (equalTo != null) {
      query = query.equalTo(equalTo);
    }
    
    return await query.get();
  }
}
