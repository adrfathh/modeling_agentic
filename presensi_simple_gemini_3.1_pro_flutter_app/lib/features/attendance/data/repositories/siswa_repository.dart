// lib/features/siswa/data/repositories/siswa_repository.dart
//
// Siswa Repository — Mock Implementation
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:attendance_app/core/theme/status_color_resolver.dart';
import 'package:attendance_app/features/attendance/domain/entities/attendance_timeline_entry.dart';
import 'package:attendance_app/features/attendance/domain/entities/student_attendance.dart';

/// Abstract repository interface for siswa data operations.
abstract class SiswaRepository {
  Future<SiswaDashboardData> getDashboardData();
  Future<ActiveSession?> getCurrentSession();
  Future<bool> isFrozen();
  Future<List<AttendanceTimelineEntry>> getAttendanceHistory({
    required DateTime startDate,
    required DateTime endDate,
  });
}

/// Mock implementation with realistic demo data.
class MockSiswaRepository implements SiswaRepository {
  @override
  Future<SiswaDashboardData> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return SiswaDashboardData(
      profile: const StudentProfile(
        id: 'siswa_001',
        name: 'Ahmad Rizky Pratama',
        kelas: 'XI IPA 2',
        nisn: '0045678901',
        boundDeviceId: 'demo_device',
      ),
      currentSession: const ActiveSession(
        id: 'session_001',
        mapelName: 'Matematika',
        jamKe: 3,
        jamMulai: '08:30',
        jamSelesai: '09:15',
        guruName: 'Bpk. Hendro, S.Pd.',
        ruangKelas: 'R.201',
        isActive: true,
      ),
      todayEntries: _mockTodayEntries(),
      hadirCount: 2,
      terlambatCount: 0,
      alpaCount: 0,
      izinSakitCount: 0,
      isFrozen: false,
      failCount: 0,
    );
  }

  @override
  Future<ActiveSession?> getCurrentSession() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const ActiveSession(
      id: 'session_001',
      mapelName: 'Matematika',
      jamKe: 3,
      jamMulai: '08:30',
      jamSelesai: '09:15',
      guruName: 'Bpk. Hendro, S.Pd.',
      ruangKelas: 'R.201',
      isActive: true,
    );
  }

  @override
  Future<bool> isFrozen() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return false;
  }

  @override
  Future<List<AttendanceTimelineEntry>> getAttendanceHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockWeekEntries();
  }

  List<AttendanceTimelineEntry> _mockTodayEntries() {
    final today = DateTime.now();
    return [
      AttendanceTimelineEntry(
        id: 'entry_01',
        date: today,
        dayName: _dayName(today),
        status: AttendanceStatus.hadir,
        jamLabel: 'Jam ke-1 — Bahasa Indonesia',
        primaryMeta: 'Barcode scan pukul 07.05 WIB',
        secondaryMeta: '✓ Auto approved – 07.12 WIB',
      ),
      AttendanceTimelineEntry(
        id: 'entry_02',
        date: today,
        dayName: _dayName(today),
        status: AttendanceStatus.hadir,
        jamLabel: 'Jam ke-2 — Fisika',
        primaryMeta: 'Barcode scan pukul 08.00 WIB',
        secondaryMeta: '✓ Auto approved – 08.05 WIB',
      ),
      AttendanceTimelineEntry(
        id: 'entry_03',
        date: today,
        dayName: _dayName(today),
        status: AttendanceStatus.waiting,
        jamLabel: 'Jam ke-3 — Matematika',
        primaryMeta: 'Barcode scan pukul 08.35 WIB',
      ),
    ];
  }

  List<AttendanceTimelineEntry> _mockWeekEntries() {
    final today = DateTime.now();
    return [
      AttendanceTimelineEntry(
        id: 'w_01',
        date: today,
        dayName: _dayName(today),
        status: AttendanceStatus.waiting,
        jamLabel: 'Jam ke-3 — Matematika',
        primaryMeta: 'Barcode scan pukul 08.35 WIB',
      ),
      AttendanceTimelineEntry(
        id: 'w_02',
        date: today.subtract(const Duration(days: 1)),
        dayName: _dayName(today.subtract(const Duration(days: 1))),
        status: AttendanceStatus.hadir,
        jamLabel: 'Jam ke-2 — Bahasa Indonesia',
        primaryMeta: 'Barcode scan 06.55 & biometrik 12.59 WIB',
        secondaryMeta: '✓ Auto approved – 07.12 dan 13.20 WIB',
      ),
      AttendanceTimelineEntry(
        id: 'w_03',
        date: today.subtract(const Duration(days: 2)),
        dayName: _dayName(today.subtract(const Duration(days: 2))),
        status: AttendanceStatus.alpa,
        jamLabel: 'Jam ke-3 — Fisika',
        primaryMeta: 'Tidak ada scan 06.55 & 12.55 WIB',
        secondaryMeta: '✓ Auto-approved 07.00 dan 13.00 WIB',
      ),
      AttendanceTimelineEntry(
        id: 'w_04',
        date: today.subtract(const Duration(days: 3)),
        dayName: _dayName(today.subtract(const Duration(days: 3))),
        status: AttendanceStatus.unavailable,
        jamLabel: 'Libur Sekolah',
        primaryMeta: 'Auto-record 00.00 WIB',
      ),
      AttendanceTimelineEntry(
        id: 'w_05',
        date: today.subtract(const Duration(days: 4)),
        dayName: _dayName(today.subtract(const Duration(days: 4))),
        status: AttendanceStatus.terlambat,
        jamLabel: 'Jam ke-1 — PKN',
        primaryMeta: 'Barcode scan pukul 07.25 WIB',
        secondaryMeta: 'Terlambat 10 menit',
      ),
      AttendanceTimelineEntry(
        id: 'w_06',
        date: today.subtract(const Duration(days: 5)),
        dayName: _dayName(today.subtract(const Duration(days: 5))),
        status: AttendanceStatus.hadir,
        jamLabel: 'Jam ke-1 — Seni Budaya',
        primaryMeta: 'Manual 06.55 & 12.59 WIB',
        secondaryMeta: '✓ Manual-approved 07.12 dan 13.20 WIB',
      ),
    ];
  }

  String _dayName(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[d.weekday - 1];
  }
}
