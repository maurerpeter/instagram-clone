import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  /// Throws [CacheException] if no cached data is present.
  Future<void> deleteToken();

  /// Throws [CacheException] if no cached data is present.
  Future<bool> hasToken();

  /// Throws [CacheException] if no cached data is present.
  Future<void> persistToken(String token);

  /// Throws [CacheException] if no cached data is present.
  Future<String> getToken();
}

const CACHED_TOKEN = 'CACHED_INSTAGRAM_CLONE_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences storage;

  AuthLocalDataSourceImpl({@required this.storage});

  @override
  Future<void> deleteToken() async {
    try {
      await storage.remove(CACHED_TOKEN);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<bool> hasToken() async {
    final String value = storage.getString(CACHED_TOKEN);
    return Future.value(value != null);
  }

  @override
  Future<void> persistToken(String token) async {
    return storage.setString(CACHED_TOKEN, token);
  }

  @override
  Future<String> getToken() async {
    final String value = storage.getString(CACHED_TOKEN);
    if (value == null) {
      throw CacheException();
    }
    return Future.value(value);
  }
}
