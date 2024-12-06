import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_dto.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserDTO user);
  Future<UserDTO?> getLastUser();
  Future<void> clearUserData();
}

// ignore: constant_identifier_names
const CACHED_USER_KEY = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});
  // Renomeando o parâmetro sharedPreferences para prefs
  // AuthLocalDataSourceImpl({required SharedPreferences prefs});

  @override
  Future<void> cacheUser(UserDTO user) async {
    await sharedPreferences.setString(
      CACHED_USER_KEY,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<UserDTO?> getLastUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER_KEY);
    if (jsonString != null) {
      return UserDTO.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearUserData() async {
    await sharedPreferences.remove(CACHED_USER_KEY);
  }
}
