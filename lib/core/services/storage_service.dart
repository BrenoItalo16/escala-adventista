import 'package:shared_preferences/shared_preferences.dart';
import '../error/exceptions.dart';
import './cache_service.dart';

abstract class StorageService {
  Future<bool> setAuthState(bool isAuthenticated);
  Future<bool> getAuthState();
  Future<bool> clearAuthState();
  Future<bool> setToken(String token);
  Future<String?> getToken();
  Future<bool> clearToken();
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}

class StorageServiceImpl implements StorageService {
  final SharedPreferences _prefs;
  late final CacheService _cache;
  static const String _authKey = 'auth_state';
  static const String _tokenKey = 'auth_token';
  static const Duration _tokenCacheDuration = Duration(hours: 1);

  StorageServiceImpl({required SharedPreferences prefs}) : _prefs = prefs {
    _cache = CacheService(_prefs);
  }

  @override
  Future<bool> setAuthState(bool isAuthenticated) async {
    return await setBool(_authKey, isAuthenticated);
  }

  @override
  Future<bool> getAuthState() async {
    return await getBool(_authKey) ?? false;
  }

  @override
  Future<bool> clearAuthState() async {
    return await remove(_authKey);
  }

  @override
  Future<bool> setToken(String token) async {
    try {
      await _cache.set(_tokenKey, token, expiration: _tokenCacheDuration);
      return await _prefs.setString(_tokenKey, token);
    } catch (e) {
      throw StorageException('Failed to save token: ${e.toString()}');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      // Primeiro tenta obter do cache
      final cachedToken = _cache.get<String>(_tokenKey);
      if (cachedToken != null) {
        return cachedToken;
      }

      // Se não encontrar no cache, busca do SharedPreferences
      final token = _prefs.getString(_tokenKey);
      if (token != null) {
        // Atualiza o cache
        await _cache.set(_tokenKey, token, expiration: _tokenCacheDuration);
      }
      return token;
    } catch (e) {
      throw StorageException('Failed to get token: ${e.toString()}');
    }
  }

  @override
  Future<bool> clearToken() async {
    try {
      await _cache.remove(_tokenKey);
      return await _prefs.remove(_tokenKey);
    } catch (e) {
      throw StorageException('Failed to clear token: ${e.toString()}');
    }
  }

  @override
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      throw StorageException('Erro ao salvar string: $key');
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw StorageException('Erro ao ler string: $key');
    }
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      throw StorageException('Erro ao salvar boolean: $key');
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw StorageException('Erro ao ler boolean: $key');
    }
  }

  @override
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      throw StorageException('Erro ao remover chave: $key');
    }
  }

  @override
  Future<bool> clear() async {
    try {
      await _cache.clear();
      return await _prefs.clear();
    } catch (e) {
      throw StorageException('Erro ao limpar armazenamento');
    }
  }
}
