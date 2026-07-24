// lib/core/auth/jwt_decoder.dart
//
// JWT Decode & Validation Service
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'dart:convert';

/// Service for decoding and validating JWT tokens.
///
/// Validates:
/// 1. Token structure (3-part base64)
/// 2. Expiry time (exp claim)
/// 3. Required claims presence (role, userId)
class JwtDecoder {
  JwtDecoder._();

  /// Decode JWT payload without signature verification.
  /// In production, signature verification should be done server-side.
  ///
  /// Returns decoded claims map, or null if token is invalid/expired.
  static Map<String, dynamic>? validateAndDecode(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode payload (part 1)
      final payload = _decodeBase64(parts[1]);
      final claims = json.decode(payload) as Map<String, dynamic>;

      // Validate expiry
      final exp = claims['exp'] as int?;
      if (exp == null) return null;

      final expiryDate =
          DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
      if (DateTime.now().toUtc().isAfter(expiryDate)) {
        return null; // Token expired
      }

      // Validate required claims
      if (!claims.containsKey('role') || !claims.containsKey('userId')) {
        return null;
      }

      return claims;
    } catch (_) {
      return null; // Malformed token
    }
  }

  /// Extract role claim from token without full validation.
  static String? extractRole(String token) {
    final claims = validateAndDecode(token);
    return claims?['role'] as String?;
  }

  /// Extract userId claim from token.
  static String? extractUserId(String token) {
    final claims = validateAndDecode(token);
    return claims?['userId'] as String?;
  }

  /// Extract deviceId claim from token (for hardware binding).
  static String? extractDeviceId(String token) {
    final claims = validateAndDecode(token);
    return claims?['deviceId'] as String?;
  }

  static String _decodeBase64(String str) {
    // Add padding if needed
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Invalid base64 string');
    }
    return utf8.decode(base64Url.decode(output));
  }
}
