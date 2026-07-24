// lib/core/auth/token_storage.dart
//
// Secure Token Storage
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage wrapper for JWT access/refresh tokens.
///
/// Uses FlutterSecureStorage (Keychain on iOS, EncryptedSharedPreferences on Android).
/// All token operations are async and encrypted at rest.
class TokenStorage {
  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  /// Get the stored access token, or null if not present.
  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  /// Get the stored refresh token, or null if not present.
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  /// Save access and refresh tokens.
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  /// Clear all stored tokens (logout / session termination).
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if an access token exists.
  Future<bool> hasToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }
}
