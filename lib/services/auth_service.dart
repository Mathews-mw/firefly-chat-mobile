import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _authTokenKey = "firefly@jwt_token";

  Future<void> saveToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: _authTokenKey);
  }
}
