// lib/features/shared/widgets/segmented_tab_bar.dart
//
// Segmented Attendance Tab Bar
// Zero-Trust Attendance Protocol · Design System V5
// ═══════════════════════════════════════════════════
// VISUAL REFERENCE: All screens in Image 1 & Image 2
// Tab "Daily" / "Payroll Schedule" / "Monthly"

import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

/// Segmented tab bar with underline indicator.
///
/// Specifications:
///   - Active indicator: 2dp solid #3182CE underline
///   - Active label: 14sp, w600, #3182CE
///   - Inactive label: 14sp, w400, #718096
///   - Background: #FFFFFF
///   - Bottom divider: 1dp #F0F0F0
class SegmentedAttendanceTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController controller;
  final List<String> labels;

  const SegmentedAttendanceTabBar({
    super.key,
    required this.controller,
    required this.labels,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColorTokens.surfaceCard,
      child: TabBar(
        controller: controller,
        tabs: labels.map((l) => Tab(text: l)).toList(),

        // Indicator
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: AppDimensions.tabIndicatorH,
            color: AppColorTokens.activePrimary,
          ),
          insets: EdgeInsets.zero,
        ),
        indicatorSize: TabBarIndicatorSize.label,

        // Label colors
        labelColor: AppColorTokens.activePrimary,
        unselectedLabelColor: AppColorTokens.textTertiary,
        labelStyle: AppTextStyles.body2,
        unselectedLabelStyle: AppTextStyles.body1.copyWith(
          color: AppColorTokens.textTertiary,
        ),

        // Surface
        overlayColor: WidgetStateProperty.all(
          AppColorTokens.surfacePrimary(),
        ),
        dividerColor: AppColorTokens.divider,
        dividerHeight: AppDimensions.dividerH,

        // Behavior
        isScrollable: labels.length > 3,
        tabAlignment: labels.length > 3 ? TabAlignment.start : null,
      ),
    );
  }
}
