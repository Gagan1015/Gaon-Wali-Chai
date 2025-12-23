import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userPhoneKey = 'user_phone';

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Save user info
  Future<void> saveUserInfo(int userId, String? phone) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
    if (phone != null) {
      await _storage.write(key: _userPhoneKey, value: phone);
    }
  }

  // Get user phone
  Future<String?> getUserPhone() async {
    return await _storage.read(key: _userPhoneKey);
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
