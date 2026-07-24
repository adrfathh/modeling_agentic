// lib/features/shared/widgets/attendance_summary_counter.dart
//
// Attendance Summary Counter Row
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// 3-item row: Present / Waiting / Absent with dots + counts

import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

/// A row of summary counters with colored dots and vertical dividers.
///
/// Used in: IndividualAttendanceDetailScreen summary card
class AttendanceSummaryCounter extends StatelessWidget {
  final List<SummaryItem> items;

  const AttendanceSummaryCounter({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(child: _CounterItem(item: items[i])),
            if (i < items.length - 1)
              VerticalDivider(
                width: 1,
                thickness: AppDimensions.dividerH,
                color: AppColorTokens.divider,
                indent: 4,
                endIndent: 4,
              ),
          ],
        ],
      ),
    );
  }
}

class SummaryItem {
  final int count;
  final String label;
  final Color dotColor;

  const SummaryItem({
    required this.count,
    required this.label,
    required this.dotColor,
  });
}

class _CounterItem extends StatelessWidget {
  final SummaryItem item;
  const _CounterItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: AppDimensions.timelineDotSm,
                height: AppDimensions.timelineDotSm,
                decoration: BoxDecoration(
                  color: item.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                item.count.toString(),
                style: AppTextStyles.headline2,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(item.label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
