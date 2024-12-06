import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  static String get databaseUrl => dotenv.env['FIREBASE_DATABASE_URL'] ?? '';
  
  static Future<void> init() async {
    await dotenv.load();
  }
}
