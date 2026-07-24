// lib/features/shared/widgets/date_range_navigator.dart
//
// Date Range Navigator
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// "< Sun 10 – Sat 23 November 2025 >"

import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import '../../../core/utils/timestamp_formatter.dart';

/// Date range navigation bar with previous/next controls.
///
/// Displays formatted date range with optional update indicator dot.
class DateRangeNavigator extends StatelessWidget {
  final DateTime weekStart;
  final DateTime weekEnd;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  /// Show blue notification dot (indicates new data available)
  final bool hasUpdate;

  const DateRangeNavigator({
    super.key,
    required this.weekStart,
    required this.weekEnd,
    required this.onPrevious,
    required this.onNext,
    this.hasUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColorTokens.surfaceCard,
        border: Border(
          bottom: BorderSide(
            color: AppColorTokens.divider,
            width: AppDimensions.dividerH,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol kiri
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            color: AppColorTokens.activePrimary,
            onPressed: onPrevious,
            splashRadius: 20,
            iconSize: 24,
          ),

          // Label range + dot
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    TimestampFormatter.dateRange(weekStart, weekEnd),
                    style: AppTextStyles.body2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasUpdate) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColorTokens.activePrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Tombol kanan
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            color: AppColorTokens.activePrimary,
            onPressed: onNext,
            splashRadius: 20,
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}
