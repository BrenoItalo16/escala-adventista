import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences _prefs;
  static const String _cachePrefix = 'cache_';
  static const Duration defaultExpiration = Duration(minutes: 30);

  CacheService(this._prefs);

  Future<bool> set(String key, dynamic value, {Duration? expiration}) async {
    final expirationTime = DateTime.now().add(expiration ?? defaultExpiration);
    final cacheData = {
      'value': value,
      'expiration': expirationTime.millisecondsSinceEpoch,
    };
    return await _prefs.setString(_cachePrefix + key, jsonEncode(cacheData));
  }

  T? get<T>(String key) {
    final data = _prefs.getString(_cachePrefix + key);
    if (data == null) return null;

    final cacheData = jsonDecode(data);
    final expiration = DateTime.fromMillisecondsSinceEpoch(cacheData['expiration']);

    if (DateTime.now().isAfter(expiration)) {
      _prefs.remove(_cachePrefix + key);
      return null;
    }

    return cacheData['value'] as T;
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(_cachePrefix + key);
  }

  Future<bool> clear() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
    return true;
  }
}
