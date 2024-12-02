import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _authKey = 'auth_state';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> setAuthState(bool isAuthenticated) async {
    await _prefs.setBool(_authKey, isAuthenticated);
  }

  bool? getAuthState() {
    return _prefs.getBool(_authKey);
  }

  Future<void> clearAuthState() async {
    await _prefs.remove(_authKey);
  }
}
