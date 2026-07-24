// lib/features/siswa/domain/entities/student_attendance.dart
//
// Siswa Domain Entities
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:attendance_app/features/attendance/domain/entities/attendance_timeline_entry.dart';

/// Student profile model
class StudentProfile {
  final String id;
  final String name;
  final String kelas;
  final String nisn;
  final String? photoUrl;
  final String boundDeviceId;

  const StudentProfile({
    required this.id,
    required this.name,
    required this.kelas,
    required this.nisn,
    this.photoUrl,
    required this.boundDeviceId,
  });
}

/// Active class session for barcode display
class ActiveSession {
  final String id;
  final String mapelName;
  final int jamKe;
  final String jamMulai;
  final String jamSelesai;
  final String guruName;
  final String ruangKelas;
  final bool isActive;

  const ActiveSession({
    required this.id,
    required this.mapelName,
    required this.jamKe,
    required this.jamMulai,
    required this.jamSelesai,
    required this.guruName,
    required this.ruangKelas,
    required this.isActive,
  });
}

/// Student dashboard data
class SiswaDashboardData {
  final StudentProfile profile;
  final ActiveSession? currentSession;
  final List<AttendanceTimelineEntry> todayEntries;
  final int hadirCount;
  final int terlambatCount;
  final int alpaCount;
  final int izinSakitCount;
  final bool isFrozen;
  final int failCount;

  const SiswaDashboardData({
    required this.profile,
    this.currentSession,
    required this.todayEntries,
    required this.hadirCount,
    required this.terlambatCount,
    required this.alpaCount,
    this.izinSakitCount = 0,
    required this.isFrozen,
    required this.failCount,
  });
}

/// Biometric verification session
class BiometricSession {
  final String sessionId;
  final String siswaId;
  final String challenge;
  final int failCount;
  final BiometricPhase phase;

  const BiometricSession({
    required this.sessionId,
    required this.siswaId,
    required this.challenge,
    required this.failCount,
    required this.phase,
  });
}

enum BiometricPhase { activation, liveness, feedback }
