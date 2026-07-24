// lib/features/shared/models/attendance_timeline_entry.dart
//
// Timeline Entry Model
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:attendance_app/core/theme/status_color_resolver.dart';

/// Data model for a single entry in the VerticalAttendanceTimeline.
class AttendanceTimelineEntry {
  /// Unique entry identifier
  final String id;

  /// Date of the attendance entry
  final DateTime date;

  /// Short day name (e.g., "Wed", "Mon")
  final String dayName;

  /// Attendance status
  final AttendanceStatus status;

  /// Lesson label (e.g., "Jam ke-3 — Matematika")
  final String jamLabel;

  /// Primary metadata (e.g., "Barcode scan pukul 06.55 WIB")
  final String? primaryMeta;

  /// Secondary metadata (e.g., "✓ Auto approved – 07.12 WIB")
  final String? secondaryMeta;

  const AttendanceTimelineEntry({
    required this.id,
    required this.date,
    required this.dayName,
    required this.status,
    required this.jamLabel,
    this.primaryMeta,
    this.secondaryMeta,
  });
}
