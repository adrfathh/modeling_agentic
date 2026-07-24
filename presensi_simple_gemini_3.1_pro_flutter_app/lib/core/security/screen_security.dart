// lib/core/security/screen_security.dart
//
// Screen Security — FLAG_SECURE Implementation
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Wajib dipanggil di BarcodeDisplayScreen & BiometricVerifyScreen
// SEBELUM frame pertama dirender.

import 'package:flutter/services.dart';
import 'security_audit_logger.dart';

/// Platform channel implementation for screen capture protection.
///
/// Android: WindowManager.LayoutParams.FLAG_SECURE
/// iOS: Screen recording protection via UIScreen notification
///
/// CRITICAL: Must be called in initState → addPostFrameCallback
/// BEFORE any sensitive content is rendered.
class ScreenSecurity {
  ScreenSecurity._();

  static const _channel =
      MethodChannel('com.smakasihan.attendance/security');

  /// Enable screen capture protection.
  /// Screen becomes black during screenshot/recording/mirroring.
  ///
  /// Graceful degradation: logs failure but doesn't crash.
  static Future<void> enableSecureWindow() async {
    try {
      await _channel.invokeMethod('enableSecureWindow');
    } catch (e) {
      // Log error but don't crash — security degrades gracefully
      await SecurityAuditLogger.log(
        event: 'SECURE_WINDOW_ENABLE_FAIL',
        details: {'error': e.toString()},
      );
    }
  }

  /// Disable screen capture protection.
  /// Call in dispose() to restore normal behavior.
  static Future<void> disableSecureWindow() async {
    try {
      await _channel.invokeMethod('disableSecureWindow');
    } catch (_) {
      // Silent fail on disable — non-critical
    }
  }
}
