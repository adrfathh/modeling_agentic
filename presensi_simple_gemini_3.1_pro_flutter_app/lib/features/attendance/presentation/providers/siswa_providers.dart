// lib/features/siswa/presentation/providers/siswa_providers.dart
//
// Siswa Riverpod Providers
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_app/features/attendance/data/repositories/siswa_repository.dart';
import 'package:attendance_app/features/attendance/domain/entities/student_attendance.dart';
import 'package:attendance_app/features/attendance/domain/entities/attendance_timeline_entry.dart';

/// Repository provider — swap MockSiswaRepository for real implementation later
final siswaRepositoryProvider = Provider<SiswaRepository>((ref) {
  return MockSiswaRepository();
});

/// Dashboard data provider
final siswaDashboardProvider = FutureProvider<SiswaDashboardData>((ref) async {
  final repo = ref.read(siswaRepositoryProvider);
  return repo.getDashboardData();
});

/// Current active session provider
final currentSessionProvider = FutureProvider<ActiveSession?>((ref) async {
  final repo = ref.read(siswaRepositoryProvider);
  return repo.getCurrentSession();
});

/// Freeze state provider
final freezeStateProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(siswaRepositoryProvider);
  return repo.isFrozen();
});

/// Attendance history provider
final attendanceHistoryProvider = FutureProvider.family<
    List<AttendanceTimelineEntry>, ({DateTime start, DateTime end})>(
  (ref, dateRange) async {
    final repo = ref.read(siswaRepositoryProvider);
    return repo.getAttendanceHistory(
      startDate: dateRange.start,
      endDate: dateRange.end,
    );
  },
);

/// Barcode countdown provider — ticks every second
final barcodeCountdownProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return 30 - (now % 30);
  });
});
