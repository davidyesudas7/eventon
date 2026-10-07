import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  String? _inMemoryAccessToken;
  String? _inMemoryRefreshToken;

  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _inMemoryAccessToken = accessToken;
    _inMemoryRefreshToken = refreshToken;
    try {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    } catch (_) {
      // SecureStorage fallback to in-memory if secure storage fails on unsupported platform
    }
  }

  Future<String?> getAccessToken() async {
    if (_inMemoryAccessToken != null) return _inMemoryAccessToken;
    try {
      _inMemoryAccessToken = await _storage.read(key: _accessTokenKey);
    } catch (_) {}
    return _inMemoryAccessToken;
  }

  Future<String?> getRefreshToken() async {
    if (_inMemoryRefreshToken != null) return _inMemoryRefreshToken;
    try {
      _inMemoryRefreshToken = await _storage.read(key: _refreshTokenKey);
    } catch (_) {}
    return _inMemoryRefreshToken;
  }

  Future<void> clearTokens() async {
    _inMemoryAccessToken = null;
    _inMemoryRefreshToken = null;
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
    } catch (_) {}
  }
}
