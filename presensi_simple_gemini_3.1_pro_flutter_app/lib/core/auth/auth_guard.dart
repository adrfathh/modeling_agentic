// lib/core/auth/auth_guard.dart
//
// Route Guard — AuthGuard Implementation
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// SETIAP route wajib melewati AuthGuard sebelum render frame pertama.
// Cross-role access → session termination [SRS-ARCH-002].

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../security/hardware_binding.dart';
import '../security/security_audit_logger.dart';
import 'jwt_decoder.dart';
import 'role_model.dart';
import 'token_storage.dart';

/// GoRouter redirect callback implementing the 6-step Zero-Trust validation.
///
/// Pipeline:
/// 1. Token existence check
/// 2. JWT structure & signature validation
/// 3. Expiry verification
/// 4. Role extraction
/// 5. Route-role authorization
/// 6. Hardware binding validation (Siswa only)
class AuthGuard {
  final TokenStorage _tokenStorage;

  AuthGuard({TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? TokenStorage();

  /// Main redirect callback for GoRouter.
  /// Returns redirect path, or null if access is allowed.
  Future<String?> redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final currentPath = state.matchedLocation;

    // Public routes — no auth required
    if (_isPublicRoute(currentPath)) return null;

    // Step 1: Ambil token dari secure storage
    final token = await _tokenStorage.getAccessToken();

    // Step 2: Jika tidak ada token → paksa ke login
    if (token == null || token.isEmpty) {
      return '/login';
    }

    // Step 3: Validasi structure + expiry JWT
    final claims = JwtDecoder.validateAndDecode(token);
    if (claims == null) {
      // Token expired/invalid — clear & redirect
      await _tokenStorage.clearAll();
      return '/login';
    }

    // Step 4: Ekstrak role dari JWT claim
    final role = UserRole.fromClaim(claims['role'] as String?);
    if (role == null) {
      await _tokenStorage.clearAll();
      return '/login';
    }

    // Step 5: Validasi kecocokan route dengan role
    if (!_isRouteAllowedForRole(currentPath, role)) {
      // Log security event — cross-role access attempt
      await SecurityAuditLogger.log(
        event: 'CROSS_ROLE_ACCESS_ATTEMPT',
        details: {
          'attemptedRoute': currentPath,
          'claimedRole': role.name,
          'userId': claims['userId'],
        },
      );
      // Session termination
      await _tokenStorage.clearAll();
      return '/login';
    }

    // Step 6 (Khusus Siswa): Validasi hardware binding
    if (role == UserRole.siswa) {
      final currentDeviceId = await HardwareBinding.getCurrentDeviceId();
      final boundDeviceId = claims['deviceId'] as String?;
      if (boundDeviceId != null && currentDeviceId != boundDeviceId) {
        return '/device-mismatch';
      }
    }

    // All checks passed — access allowed
    return null;
  }

  /// Check if a route is public (no auth required).
  bool _isPublicRoute(String path) {
    const publicRoutes = {'/login', '/device-mismatch'};
    return publicRoutes.contains(path);
  }

  /// Check if a route is allowed for the given role.
  bool _isRouteAllowedForRole(String path, UserRole role) {
    // Normalize parameterized routes
    final normalizedPath = _normalizePath(path);

    final allowedPrefixes = switch (role) {
      UserRole.adminIT => ['/admin/'],
      UserRole.guru => ['/guru/'],
      UserRole.siswa => ['/siswa/'],
    };

    return allowedPrefixes.any((prefix) => normalizedPath.startsWith(prefix));
  }

  /// Normalize dynamic route segments for comparison.
  String _normalizePath(String path) {
    // Remove trailing slashes
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }
    return path;
  }
}
