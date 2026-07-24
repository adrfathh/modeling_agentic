// lib/features/shared/widgets/status_dot.dart
//
// Status Dot — Reusable Colored Indicator
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/status_color_resolver.dart';

/// Size variants for the status dot.
enum DotSize {
  /// 8dp — small timeline dots, legend dots
  sm,

  /// 12dp — standard timeline dots
  md,

  /// 14dp — web timeline dots, emphasis
  lg,
}

/// A simple colored circle indicator for attendance status.
///
/// Color is resolved canonically from [StatusColorResolver].
class StatusDot extends StatelessWidget {
  final AttendanceStatus status;
  final DotSize size;

  /// Optional: override color directly (use sparingly).
  final Color? overrideColor;

  const StatusDot({
    super.key,
    required this.status,
    this.size = DotSize.md,
    this.overrideColor,
  });

  double get _diameter => switch (size) {
        DotSize.sm => AppDimensions.timelineDotSm,
        DotSize.md => AppDimensions.timelineDotMd,
        DotSize.lg => AppDimensions.timelineDotLg,
      };

  @override
  Widget build(BuildContext context) {
    final color = overrideColor ?? StatusColorResolver.dotColor(status);

    return Container(
      width: _diameter,
      height: _diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
