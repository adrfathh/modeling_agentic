// lib/features/shared/widgets/status_chip.dart
//
// Status Chip — Pill-shaped Status Badge
// Zero-Trust Attendance Protocol · Design System V5
// ═══════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/status_color_resolver.dart';

/// Size variants for the status chip.
enum ChipSize { sm, md, lg }

/// A pill-shaped badge displaying attendance status.
///
/// Features:
/// - Color-coded background (12% opacity) + border
/// - Pill shape (borderRadius: 999)
/// - 3 sizes: sm (10sp), md (11sp), lg (13sp)
/// - Label from StatusColorResolver or custom override
class StatusChip extends StatelessWidget {
  final AttendanceStatus status;
  final ChipSize size;
  final String? overrideLabel;

  const StatusChip({
    super.key,
    required this.status,
    this.size = ChipSize.md,
    this.overrideLabel,
  });

  double get _fontSize => switch (size) {
        ChipSize.sm => 10.0,
        ChipSize.md => 11.0,
        ChipSize.lg => 13.0,
      };

  EdgeInsets get _padding => switch (size) {
        ChipSize.sm =>
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        ChipSize.md =>
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        ChipSize.lg =>
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      };

  @override
  Widget build(BuildContext context) {
    final color = StatusColorResolver.dotColor(status);
    final label = overrideLabel ?? StatusColorResolver.statusLabel(status);

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color, width: 1.0),
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          color: color,
          height: 1.2,
        ),
      ),
    );
  }
}
