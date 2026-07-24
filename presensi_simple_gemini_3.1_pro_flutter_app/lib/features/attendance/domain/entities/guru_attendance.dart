// lib/features/guru_mapel/domain/entities/guru_attendance.dart
import 'package:attendance_app/features/attendance/domain/entities/attendance_timeline_entry.dart';
import 'package:attendance_app/core/theme/status_color_resolver.dart';

class ClassAttendanceGroup {
  final DateTime date;
  final String dayName;
  final int hadirCount;
  final int alpaCount;
  final List<String> hadirNames;
  final List<String> alpaNames;
  final AttendanceStatus dayStatus;

  const ClassAttendanceGroup({
    required this.date, required this.dayName, required this.hadirCount,
    required this.alpaCount, required this.hadirNames, required this.alpaNames,
    required this.dayStatus,
  });
}

class ApprovalEntry {
  final String id;
  final String siswaName;
  final String siswaPhotoUrl;
  final String kelas;
  final String ruangKelas;
  final int jamKe;
  final String mapelName;
  final DateTime timestamp;
  final AttendanceStatus status;
  final List<SessionStatus> todaySessions;
  final List<AttendanceTimelineEntry> history;

  const ApprovalEntry({
    required this.id, required this.siswaName, this.siswaPhotoUrl = '',
    required this.kelas, required this.ruangKelas, required this.jamKe,
    required this.mapelName, required this.timestamp, required this.status,
    required this.todaySessions, required this.history,
  });
}

class SessionStatus {
  final int jamKe;
  final AttendanceStatus status;
  final String label;
  const SessionStatus({required this.jamKe, required this.status, required this.label});
}

class GuruDashboardData {
  final String guruName;
  final String mapelName;
  final String currentClass;
  final int totalSiswa;
  final int hadirToday;
  final int alpaToday;
  final int waitingCount;
  final bool isInsideGeofence;
  const GuruDashboardData({
    required this.guruName, required this.mapelName, required this.currentClass,
    required this.totalSiswa, required this.hadirToday, required this.alpaToday,
    required this.waitingCount, required this.isInsideGeofence,
  });
}
