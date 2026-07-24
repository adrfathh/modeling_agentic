// lib/core/network/connectivity_service.dart
//
// Connectivity Monitoring Service
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity status enum for simplified state management.
enum ConnectivityStatus {
  /// Device is online with internet access
  online,

  /// Device is offline — cache mode active
  offline,

  /// Currently syncing cached data
  syncing,
}

/// Provider for real-time connectivity status monitoring.
final connectivityProvider =
    StreamNotifierProvider<ConnectivityNotifier, ConnectivityStatus>(
  ConnectivityNotifier.new,
);

/// Notifier that monitors device connectivity and manages sync state.
class ConnectivityNotifier extends StreamNotifier<ConnectivityStatus> {
  @override
  Stream<ConnectivityStatus> build() async* {
    final connectivity = Connectivity();

    // Check initial status
    final initial = await connectivity.checkConnectivity();
    yield _mapStatus(initial);

    // Listen for changes
    await for (final result in connectivity.onConnectivityChanged) {
      yield _mapStatus(result);
    }
  }

  ConnectivityStatus _mapStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      return ConnectivityStatus.offline;
    }
    return ConnectivityStatus.online;
  }
}
