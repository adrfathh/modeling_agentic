// lib/features/guru_mapel/presentation/providers/guru_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_app/features/attendance/data/repositories/guru_repository.dart';
import 'package:attendance_app/features/attendance/domain/entities/guru_attendance.dart';

final guruRepositoryProvider = Provider<GuruRepository>((_) => MockGuruRepository());

final guruDashboardProvider = FutureProvider<GuruDashboardData>((ref) async {
  return ref.read(guruRepositoryProvider).getDashboardData();
});

final attendanceGroupsProvider = FutureProvider.family<
    List<ClassAttendanceGroup>, ({DateTime start, DateTime end})>((ref, range) async {
  return ref.read(guruRepositoryProvider).getAttendanceGroups(range.start, range.end);
});

final approvalEntryProvider = FutureProvider.family<ApprovalEntry, String>((ref, id) async {
  return ref.read(guruRepositoryProvider).getApprovalEntry(id);
});
