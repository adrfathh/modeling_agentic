// lib/core/auth/auth_events.dart

import 'dart:async';

/// Global event bus for authentication-related events.
class AuthEventBus {
  AuthEventBus._();

  static final StreamController<void> _logoutController = StreamController<void>.broadcast();

  /// Stream of logout events. Listen to this to redirect to the login screen.
  static Stream<void> get onLogoutTriggered => _logoutController.stream;

  /// Trigger a global logout event (e.g. from an expired token interceptor).
  static void triggerLogout() {
    _logoutController.add(null);
  }
}
