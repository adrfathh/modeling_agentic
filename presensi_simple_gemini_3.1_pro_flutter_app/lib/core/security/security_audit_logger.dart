// lib/core/security/security_audit_logger.dart
//
// Security Audit Logger
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Setiap mutasi state penting wajib menghasilkan log entry.

import 'package:flutter/foundation.dart';
import '../network/api_client.dart';

/// Centralized security audit logging service.
///
/// All security-relevant events MUST go through this logger:
/// - Cross-role access attempts
/// - Hardware binding mismatches
/// - Biometric failures
/// - Freeze state changes
/// - Screen security failures
/// - Manual override actions
class SecurityAuditLogger {
  SecurityAuditLogger._();

  /// Log a security event with structured details.
  ///
  /// In production, this should send to a remote audit trail API.
  /// Currently logs locally for development.
  static Future<void> log({
    required String event,
    Map<String, dynamic>? details,
  }) async {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = {
      'timestamp': timestamp,
      'event': event,
      ...?details,
    };

    try {
      await ApiClient().post('/api/audit-log', data: logEntry);
    } catch (e) {
      debugPrint('[SECURITY_AUDIT] Failed to send log to server: $e');
    }

    // Development logging
    debugPrint('[SECURITY_AUDIT] $logEntry');
  }
}
