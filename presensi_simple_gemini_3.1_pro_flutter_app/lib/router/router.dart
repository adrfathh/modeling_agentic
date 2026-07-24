// lib/app/router.dart
//
// GoRouter Configuration — Role-Based Route Mapping
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// EVERY route passes through AuthGuard before render.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_guard.dart';
import 'package:attendance_app/features/dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'package:attendance_app/features/management/presentation/screens/freeze_management_screen.dart';
import 'package:attendance_app/features/auth/presentation/screens/hardware_binding_screen.dart';
import 'package:attendance_app/features/management/presentation/screens/kurikulum_screen.dart';
import 'package:attendance_app/features/attendance/presentation/screens/approval_card_screen.dart';
import 'package:attendance_app/features/attendance/presentation/screens/attendance_list_screen.dart';
import 'package:attendance_app/features/dashboard/presentation/screens/guru_dashboard_screen.dart';
import 'package:attendance_app/features/attendance/presentation/screens/manual_override_screen.dart';
import 'package:attendance_app/features/attendance/presentation/screens/scanner_screen.dart';
import 'package:attendance_app/features/auth/presentation/screens/device_mismatch_screen.dart';
import 'package:attendance_app/features/auth/presentation/screens/login_screen.dart';
import 'package:attendance_app/features/attendance/presentation/screens/barcode_display_screen.dart';
import 'package:attendance_app/features/attendance/presentation/screens/biometric_verify_screen.dart';
import 'package:attendance_app/features/dashboard/presentation/screens/siswa_dashboard_screen.dart';

/// Application route definitions.
abstract class AppRoutes {
  AppRoutes._();

  // ── SHARED ──────────────────────────────────────────────────
  static const String login = '/login';
  static const String deviceMismatch = '/device-mismatch';

  // ── ADMIN IT ─────────────────────────────────────────────────
  static const String adminDashboard = '/admin/dashboard';
  static const String adminKurikulum = '/admin/kurikulum';
  static const String adminBinding = '/admin/hardware-binding';
  static const String adminFreeze = '/admin/freeze-management';

  // ── GURU MAPEL ────────────────────────────────────────────────
  static const String guruDashboard = '/guru/dashboard';
  static const String guruAttendance = '/guru/attendance';
  static const String guruScanner = '/guru/scanner';
  static const String guruApproval = '/guru/approval/:entryId';
  static const String guruManualOverride = '/guru/manual-override/:siswaId';

  // ── SISWA ─────────────────────────────────────────────────────
  static const String siswaDashboard = '/siswa/dashboard';
  static const String siswaBarcode = '/siswa/barcode';
  static const String siswaBiometric = '/siswa/biometric-verify';
}

/// Build the application router with AuthGuard.
GoRouter buildRouter() {
  final authGuard = AuthGuard();

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    redirect: authGuard.redirect,
    routes: [
      // ── SHARED ROUTES ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.deviceMismatch,
        builder: (context, state) => const DeviceMismatchScreen(),
      ),

      // ── ADMIN IT ROUTES ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminKurikulum,
        builder: (context, state) => const KurikulumScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminBinding,
        builder: (context, state) => const HardwareBindingScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminFreeze,
        builder: (context, state) => const FreezeManagementScreen(),
      ),

      // ── GURU MAPEL ROUTES ────────────────────────────────────
      GoRoute(
        path: AppRoutes.guruDashboard,
        builder: (context, state) => const GuruDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.guruAttendance,
        builder: (context, state) => const AttendanceListScreen(),
      ),
      GoRoute(
        path: AppRoutes.guruScanner,
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: AppRoutes.guruApproval,
        builder: (context, state) {
          final entryId = state.pathParameters['entryId'] ?? '';
          return ApprovalCardScreen(entryId: entryId);
        },
      ),
      GoRoute(
        path: AppRoutes.guruManualOverride,
        builder: (context, state) {
          final siswaId = state.pathParameters['siswaId'] ?? '';
          return ManualOverrideScreen(siswaId: siswaId);
        },
      ),

      // ── SISWA ROUTES ─────────────────────────────────────────
      GoRoute(
        path: AppRoutes.siswaDashboard,
        builder: (context, state) => const SiswaDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.siswaBarcode,
        builder: (context, state) => const BarcodeDisplayScreen(),
      ),
      GoRoute(
        path: AppRoutes.siswaBiometric,
        builder: (context, state) => const BiometricVerifyScreen(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Halaman tidak ditemukan: ${state.error}'),
      ),
    ),
  );
}
