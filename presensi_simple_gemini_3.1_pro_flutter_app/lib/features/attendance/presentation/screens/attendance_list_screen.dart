// lib/features/guru_mapel/presentation/screens/attendance_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:attendance_app/router/router.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/core/theme/status_color_resolver.dart';
import 'package:attendance_app/core/widgets/date_range_navigator.dart';
import 'package:attendance_app/core/widgets/segmented_tab_bar.dart';
import 'package:attendance_app/features/attendance/presentation/providers/guru_providers.dart';

class AttendanceListScreen extends ConsumerStatefulWidget {
  const AttendanceListScreen({super.key});
  @override
  ConsumerState<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends ConsumerState<AttendanceListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late DateTime _weekStart;
  late DateTime _weekEnd;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this, initialIndex: 1);
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday % 7));
    _weekEnd = _weekStart.add(const Duration(days: 13));
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final range = (start: _weekStart, end: _weekEnd);
    final groupsAsync = ref.watch(attendanceGroupsProvider(range));

    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: AppColorTokens.activePrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Matematika Attendance'),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), color: AppColorTokens.textTertiary, onPressed: () {}),
          TextButton(
            onPressed: () {},
            child: Text('Change', style: AppTextStyles.body2.copyWith(color: AppColorTokens.activePrimary)),
          ),
        ],
      ),
      body: Column(children: [
        SegmentedAttendanceTabBar(controller: _tabCtrl, labels: const ['Daily', 'Payroll Schedule', 'Monthly']),
        DateRangeNavigator(
          weekStart: _weekStart, weekEnd: _weekEnd, hasUpdate: true,
          onPrevious: () => setState(() { _weekStart = _weekStart.subtract(const Duration(days: 14)); _weekEnd = _weekEnd.subtract(const Duration(days: 14)); }),
          onNext: () => setState(() { _weekStart = _weekStart.add(const Duration(days: 14)); _weekEnd = _weekEnd.add(const Duration(days: 14)); }),
        ),
        Expanded(
          child: groupsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColorTokens.activePrimary)),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (groups) => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groups.length,
              itemBuilder: (_, i) => _DayGroupCard(group: groups[i]),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.guruScanner),
        backgroundColor: AppColorTokens.activePrimary,
        icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColorTokens.textOnPrimary),
        label: Text('Mulai Presensi', style: AppTextStyles.body2.copyWith(color: AppColorTokens.textOnPrimary)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _DayGroupCard extends StatelessWidget {
  final dynamic group;
  const _DayGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Day dot
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 12),
          child: Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              color: StatusColorResolver.dotColor(group.dayStatus),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Date label
        SizedBox(
          width: 48,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(group.dayName, style: AppTextStyles.caption),
            Text(group.date.day.toString().padLeft(2, '0'), style: AppTextStyles.title1),
          ]),
        ),
        const SizedBox(width: 12),
        // Cards
        Expanded(
          child: Column(children: [
            _StatusGroupCard(
              label: 'Presensi', count: group.hadirCount,
              names: group.hadirNames.join(', '), dotColor: AppColorTokens.attendApprove,
            ),
            const SizedBox(height: 8),
            _StatusGroupCard(
              label: 'Alpa', count: group.alpaCount,
              names: group.alpaNames.isEmpty ? '–' : group.alpaNames.join(', '),
              dotColor: AppColorTokens.absentReject,
            ),
          ]),
        ),
      ]),
    );
  }
}

class _StatusGroupCard extends StatelessWidget {
  final String label;
  final int count;
  final String names;
  final Color dotColor;
  const _StatusGroupCard({required this.label, required this.count, required this.names, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColorTokens.surfaceCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppDimensions.shadowCard,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.body2),
          const Spacer(),
          Text('$count', style: AppTextStyles.body2),
        ]),
        const SizedBox(height: 6),
        Text(names, style: AppTextStyles.label2, maxLines: 2, overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}
