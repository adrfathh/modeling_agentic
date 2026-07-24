// lib/features/guru_mapel/data/repositories/guru_repository.dart
import 'package:attendance_app/core/theme/status_color_resolver.dart';
import 'package:attendance_app/features/attendance/domain/entities/attendance_timeline_entry.dart';
import 'package:attendance_app/features/attendance/domain/entities/guru_attendance.dart';

abstract class GuruRepository {
  Future<GuruDashboardData> getDashboardData();
  Future<List<ClassAttendanceGroup>> getAttendanceGroups(DateTime start, DateTime end);
  Future<ApprovalEntry> getApprovalEntry(String entryId);
  Future<void> approveEntry(String entryId);
  Future<void> rejectEntry(String entryId);
  Future<void> submitManualOverride({required String siswaId, required AttendanceStatus status, required String reason});
}

class MockGuruRepository implements GuruRepository {
  @override
  Future<GuruDashboardData> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const GuruDashboardData(
      guruName: 'Bpk. Hendro, S.Pd.', mapelName: 'Matematika',
      currentClass: 'XI IPA 2', totalSiswa: 32, hadirToday: 28,
      alpaToday: 2, waitingCount: 2, isInsideGeofence: true,
    );
  }

  @override
  Future<List<ClassAttendanceGroup>> getAttendanceGroups(DateTime start, DateTime end) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return [
      ClassAttendanceGroup(
        date: now, dayName: _day(now), hadirCount: 28, alpaCount: 2,
        hadirNames: ['Budi S.', 'Andi R.', 'Citra D.', 'Dian F.', 'Eka P.', 'Fajar A.', 'Gina W.'],
        alpaNames: ['Hendra K.', 'Indah L.'],
        dayStatus: AttendanceStatus.hadir,
      ),
      ClassAttendanceGroup(
        date: now.subtract(const Duration(days: 1)), dayName: _day(now.subtract(const Duration(days: 1))),
        hadirCount: 30, alpaCount: 0,
        hadirNames: ['Budi S.', 'Andi R.', 'Citra D.', 'Dian F.'],
        alpaNames: [], dayStatus: AttendanceStatus.hadir,
      ),
      ClassAttendanceGroup(
        date: now.subtract(const Duration(days: 2)), dayName: _day(now.subtract(const Duration(days: 2))),
        hadirCount: 25, alpaCount: 5,
        hadirNames: ['Budi S.', 'Andi R.', 'Citra D.'],
        alpaNames: ['Hendra K.', 'Indah L.', 'Joko M.', 'Kiki N.', 'Lina O.'],
        dayStatus: AttendanceStatus.alpa,
      ),
    ];
  }

  @override
  Future<ApprovalEntry> getApprovalEntry(String entryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    return ApprovalEntry(
      id: entryId, siswaName: 'Ahmad Rizky Pratama',
      kelas: 'XI IPA 2', ruangKelas: 'R.201', jamKe: 3,
      mapelName: 'Matematika', timestamp: now,
      status: AttendanceStatus.waiting,
      todaySessions: [
        const SessionStatus(jamKe: 1, status: AttendanceStatus.hadir, label: 'Hadir'),
        const SessionStatus(jamKe: 2, status: AttendanceStatus.unavailable, label: 'Belum Dimulai'),
      ],
      history: [
        AttendanceTimelineEntry(id: 'h1', date: now.subtract(const Duration(days: 1)), dayName: _day(now.subtract(const Duration(days: 1))),
          status: AttendanceStatus.hadir, jamLabel: 'Jam ke-2 — Bahasa Indonesia',
          primaryMeta: 'Barcode scan 06.55 WIB', secondaryMeta: '✓ Auto approved'),
        AttendanceTimelineEntry(id: 'h2', date: now.subtract(const Duration(days: 2)), dayName: _day(now.subtract(const Duration(days: 2))),
          status: AttendanceStatus.alpa, jamLabel: 'Jam ke-3 — Fisika',
          primaryMeta: 'Tidak ada scan'),
      ],
    );
  }

  @override
  Future<void> approveEntry(String entryId) async => Future.delayed(const Duration(milliseconds: 300));
  @override
  Future<void> rejectEntry(String entryId) async => Future.delayed(const Duration(milliseconds: 300));
  @override
  Future<void> submitManualOverride({required String siswaId, required AttendanceStatus status, required String reason}) async =>
      Future.delayed(const Duration(milliseconds: 400));

  String _day(DateTime d) => const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][d.weekday - 1];
}
