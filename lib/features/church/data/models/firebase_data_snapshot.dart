import 'package:firebase_database/firebase_database.dart';

class FirebaseDataSnapshot {
  final DataSnapshot snapshot;

  FirebaseDataSnapshot(this.snapshot);

  bool get exists => snapshot.exists;

  dynamic get value => snapshot.value;

  Map<String, dynamic>? asMap() {
    if (!exists || value == null) return null;
    if (value is! Map) return null;
    
    return Map<String, dynamic>.from(value as Map);
  }

  Map<String, Map<String, dynamic>> asMapOfMaps() {
    if (!exists || value == null) return {};
    if (value is! Map) return {};

    final result = <String, Map<String, dynamic>>{};
    final data = value as Map<dynamic, dynamic>;

    data.forEach((key, value) {
      if (value != null && value is Map) {
        result[key.toString()] = Map<String, dynamic>.from(value);
      }
    });

    return result;
  }
}
