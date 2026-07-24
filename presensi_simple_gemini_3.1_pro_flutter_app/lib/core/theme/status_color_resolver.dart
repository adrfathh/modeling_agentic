// lib/core/theme/status_color_resolver.dart
//
// Status Color Resolver — Utility Kanonik
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// PENTING: Satu-satunya tempat logika "status → warna" diputuskan.
// Seluruh komponen UI memanggil class ini, TIDAK menghitung sendiri.

import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';

/// All possible attendance status values in the system.
///
/// Maps directly to backend API status fields and determines
/// visual rendering across every UI component.
enum AttendanceStatus {
  /// Hadir terverifikasi biometrik atau disetujui Admin
  hadir,

  /// Hadir tapi terlambatMenit > 0
  terlambat,

  /// Dispensasi izin dari Orang Tua (approved)
  izin,

  /// Dispensasi sakit dari Orang Tua (approved)
  sakit,

  /// Tidak hadir tanpa keterangan
  alpa,

  /// Menunggu persetujuan Admin (bypass manual guru)
  waiting,

  /// Gawai siswa terkunci (countFail >= 3)
  freeze,

  /// Jam pelajaran belum dimulai / hari libur
  unavailable,

  /// Cache lokal aktif, belum sinkron ke server
  offline,
}

/// Canonical resolver for mapping [AttendanceStatus] to visual tokens.
///
/// ALL UI components MUST use this class for status → color/label resolution.
/// Direct color assignment based on status is PROHIBITED elsewhere.
class StatusColorResolver {
  StatusColorResolver._();

  /// Returns the canonical dot/indicator color for a given status.
  static Color dotColor(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.hadir => AppColorTokens.attendApprove,
      AttendanceStatus.terlambat => AppColorTokens.lateSickLeave,
      AttendanceStatus.izin => AppColorTokens.lateSickLeave,
      AttendanceStatus.sakit => AppColorTokens.lateSickLeave,
      AttendanceStatus.alpa => AppColorTokens.absentReject,
      AttendanceStatus.waiting => AppColorTokens.waitingFreeze,
      AttendanceStatus.freeze => AppColorTokens.waitingFreeze,
      AttendanceStatus.unavailable => AppColorTokens.unavailableGray,
      AttendanceStatus.offline => AppColorTokens.unavailableGray,
    };
  }

  /// Returns the canonical display label for a given status.
  static String statusLabel(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.hadir => 'Hadir',
      AttendanceStatus.terlambat => 'Terlambat',
      AttendanceStatus.izin => 'Izin',
      AttendanceStatus.sakit => 'Sakit',
      AttendanceStatus.alpa => 'Alpa',
      AttendanceStatus.waiting => 'Waiting for Approval',
      AttendanceStatus.freeze => 'Freeze State',
      AttendanceStatus.unavailable => 'Belum Dimulai',
      AttendanceStatus.offline => 'Offline Mode',
    };
  }

  /// Returns the canonical surface background color (for chips, cards).
  static Color surfaceColor(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.hadir => AppColorTokens.surfaceAttend(),
      AttendanceStatus.terlambat => AppColorTokens.surfaceLate(),
      AttendanceStatus.izin => AppColorTokens.surfaceLate(),
      AttendanceStatus.sakit => AppColorTokens.surfaceLate(),
      AttendanceStatus.alpa => AppColorTokens.surfaceAbsent(),
      AttendanceStatus.waiting => AppColorTokens.surfaceWaiting(),
      AttendanceStatus.freeze => AppColorTokens.surfaceWaiting(),
      AttendanceStatus.unavailable =>
        AppColorTokens.unavailableGray.withValues(alpha: 0.10),
      AttendanceStatus.offline =>
        AppColorTokens.unavailableGray.withValues(alpha: 0.10),
    };
  }

  /// KLAUSUL INTEGRITAS DATA (BIO V2.0 & FLOW V7.0):
  ///
  /// Status 'waiting' dan 'offline' DILARANG masuk ke
  /// kalkulasi Donut Chart Orang Tua dan grafik Kepala Sekolah.
  ///
  /// Returns `true` if the status should be included in analytics
  /// calculations (donut charts, percentage, bar graphs).
  static bool isIncludedInAnalytics(AttendanceStatus status) {
    return status != AttendanceStatus.waiting &&
        status != AttendanceStatus.offline;
  }

  /// Returns the icon data for a given status (for timeline action column).
  static IconData? actionIcon(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.waiting => Icons.access_time_rounded,
      AttendanceStatus.freeze => Icons.lock_rounded,
      _ => null,
    };
  }
}

