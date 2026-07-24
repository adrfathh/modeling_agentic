// lib/core/security/hardware_binding.dart
//
// Hardware Binding — Device UUID Validation
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Validates device identity against JWT-bound device ID.

import 'package:flutter/services.dart';

/// Hardware binding service for device identity validation.
///
/// Extracts a unique device identifier and compares it against
/// the device ID bound in the student's JWT token.
///
/// Mismatch → DeviceMismatchScreen redirect [SRS-ARCH-002]
class HardwareBinding {
  HardwareBinding._();

  static const _channel =
      MethodChannel('com.smakasihan.attendance/hardware');

  static String? _cachedDeviceId;

  /// Get the current device's unique identifier.
  ///
  /// Uses Android ID on Android, identifierForVendor on iOS.
  /// Caches the result after first call.
  static Future<String> getCurrentDeviceId() async {
    if (_cachedDeviceId != null) return _cachedDeviceId!;

    try {
      final deviceId =
          await _channel.invokeMethod<String>('getDeviceId');
      _cachedDeviceId = deviceId ?? 'unknown';
    } catch (_) {
      _cachedDeviceId = 'unknown';
    }

    return _cachedDeviceId!;
  }

  /// Validate that the current device matches the bound device ID.
  static Future<bool> validateBinding(String? boundDeviceId) async {
    if (boundDeviceId == null) return false;
    final currentId = await getCurrentDeviceId();
    return currentId == boundDeviceId;
  }

  /// Clear cached device ID (for testing).
  static void clearCache() {
    _cachedDeviceId = null;
  }
}
