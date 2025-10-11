import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// This class is a wrapper around the flutter_secure_storage package
// to make it easy to save and retrieve the user's authentication token.
class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';

  // Save the JWT token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Retrieve the JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete the JWT token (for logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
