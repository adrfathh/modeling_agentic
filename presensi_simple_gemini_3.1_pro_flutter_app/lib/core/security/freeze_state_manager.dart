// lib/core/security/freeze_state_manager.dart
//
// Freeze State Manager — Biometric Failure Counter
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Manages the biometric failure counter and freeze state.
// 3 consecutive failures → device freeze.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'security_audit_logger.dart';

/// Manages the freeze state of a student's device.
///
/// Rules:
/// - Counter increments on each biometric verification failure
/// - At count >= 3 → device enters FREEZE state
/// - FREEZE disables barcode display and all attendance features
/// - Only Admin IT can unfreeze (requires physical verification)
/// - Counter resets to 0 on successful biometric verification
class FreezeStateManager {
  static const _failCountKey = 'biometric_fail_count';
  static const _freezeStateKey = 'device_freeze_state';
  static const _freezeTimestampKey = 'freeze_timestamp';
  static const int maxFailures = 3;

  final FlutterSecureStorage _storage;

  FreezeStateManager({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  /// Get the current failure count.
  Future<int> getFailCount() async {
    final value = await _storage.read(key: _failCountKey);
    return int.tryParse(value ?? '0') ?? 0;
  }

  /// Check if the device is currently frozen.
  Future<bool> isFrozen() async {
    final value = await _storage.read(key: _freezeStateKey);
    return value == 'true';
  }

  /// Record a biometric verification failure.
  /// Returns true if device is now frozen (count >= 3).
  Future<bool> recordFailure() async {
    final currentCount = await getFailCount();
    final newCount = currentCount + 1;

    await _storage.write(key: _failCountKey, value: newCount.toString());

    if (newCount >= maxFailures) {
      await _activateFreeze();
      return true;
    }

    await SecurityAuditLogger.log(
      event: 'BIOMETRIC_FAILURE',
      details: {'failCount': newCount, 'maxAllowed': maxFailures},
    );

    return false;
  }

  /// Record a successful biometric verification — resets counter.
  Future<void> recordSuccess() async {
    await _storage.write(key: _failCountKey, value: '0');
  }

  /// Activate freeze state.
  Future<void> _activateFreeze() async {
    await _storage.write(key: _freezeStateKey, value: 'true');
    await _storage.write(
      key: _freezeTimestampKey,
      value: DateTime.now().toIso8601String(),
    );

    await SecurityAuditLogger.log(
      event: 'DEVICE_FROZEN',
      details: {
        'reason': 'Max biometric failures reached',
        'failCount': maxFailures,
      },
    );
  }

  /// Deactivate freeze state (Admin IT only — called from server sync).
  Future<void> unfreeze() async {
    await _storage.write(key: _freezeStateKey, value: 'false');
    await _storage.write(key: _failCountKey, value: '0');
    await _storage.delete(key: _freezeTimestampKey);

    await SecurityAuditLogger.log(
      event: 'DEVICE_UNFROZEN',
      details: {'action': 'admin_unfreeze'},
    );
  }

  /// Get the timestamp when freeze was activated.
  Future<DateTime?> getFreezeTimestamp() async {
    final value = await _storage.read(key: _freezeTimestampKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
