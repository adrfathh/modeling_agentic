// lib/features/admin_it/presentation/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:attendance_app/router/router.dart';

import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/core/widgets/profile_sidebar.dart';
import 'package:attendance_app/features/management/presentation/providers/admin_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(adminDashProvider);
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(
        title: const Text('Admin IT Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.person_rounded),
              color: AppColorTokens.textTertiary,
              onPressed: () {
                Scaffold.of(ctx).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: dashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColorTokens.activePrimary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => SingleChildScrollView(
          padding: AppDimensions.screenPadding,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Sistem Presensi', style: AppTextStyles.headline1),
            Text('SMA Muhammadiyah Kasihan', style: AppTextStyles.label2),
            const SizedBox(height: 20),

            // KPI Row
            Row(children: [
              _Kpi(count: '${data.totalSiswa}', label: 'Total\nSiswa', color: AppColorTokens.activePrimary),
              const SizedBox(width: 8),
              _Kpi(count: '${data.hadirToday}', label: 'Hadir\nHari Ini', color: AppColorTokens.attendApprove),
              const SizedBox(width: 8),
              _Kpi(count: '${data.alpaToday}', label: 'Alpa\nHari Ini', color: AppColorTokens.absentReject),
              const SizedBox(width: 8),
              _Kpi(count: '${data.frozenCount}', label: 'Freeze\nAktif', color: data.frozenCount > 0 ? AppColorTokens.absentReject : AppColorTokens.unavailableGray, alert: data.frozenCount > 0),
            ]),
            const SizedBox(height: 24),

            // Freeze alert
            if (data.frozenCount > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColorTokens.surfaceAbsent(),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColorTokens.absentReject),
                ),
                child: Row(children: [
                  const Icon(Icons.warning_rounded, color: AppColorTokens.absentReject, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text('${data.frozenCount} gawai siswa dalam status terkunci',
                      style: AppTextStyles.label1.copyWith(color: AppColorTokens.absentReject))),
                  TextButton(onPressed: () => context.push(AppRoutes.adminFreeze),
                    child: Text('Kelola', style: AppTextStyles.label1.copyWith(color: AppColorTokens.activePrimary))),
                ]),
              ),

            // Quick actions
            Text('Menu Sistem', style: AppTextStyles.title1),
            const SizedBox(height: 12),
            _MenuCard(icon: Icons.ice_skating_rounded, title: 'Manajemen Freeze', subtitle: '${data.frozenCount} siswa terkunci',
                color: AppColorTokens.waitingFreeze, onTap: () => context.push(AppRoutes.adminFreeze)),
            const SizedBox(height: 8),
            _MenuCard(icon: Icons.devices_rounded, title: 'Hardware Binding', subtitle: '${data.unboundDevices} perangkat belum terdaftar',
                color: AppColorTokens.activePrimary, onTap: () => context.push(AppRoutes.adminBinding)),
            const SizedBox(height: 8),
            _MenuCard(icon: Icons.school_rounded, title: 'Kurikulum & Jadwal', subtitle: 'Kelola mata pelajaran & kelas',
                color: AppColorTokens.attendApprove, onTap: () => context.push(AppRoutes.adminKurikulum)),
          ]),
        ),
      ),
      endDrawer: dashAsync.whenOrNull(
        data: (data) => const ProfileSidebar(
          name: 'Administrator',
          role: 'Admin IT',
          subtitle: 'SMA Muhammadiyah Kasihan',
        ),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String count; final String label; final Color color; final bool alert;
  const _Kpi({required this.count, required this.label, required this.color, this.alert = false});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColorTokens.surfaceCard, borderRadius: BorderRadius.circular(AppDimensions.radiusCard), boxShadow: AppDimensions.shadowCard),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(count, style: AppTextStyles.headline1.copyWith(color: color)),
          if (alert) ...[const SizedBox(width: 4), const Icon(Icons.warning_rounded, color: AppColorTokens.absentReject, size: 14)],
        ]),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ]),
    ));
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final Color color; final VoidCallback onTap;
  const _MenuCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(color: AppColorTokens.surfaceCard, borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppDimensions.radiusCard), boxShadow: AppDimensions.shadowCard),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTextStyles.body2), Text(subtitle, style: AppTextStyles.label2),
            ])),
            Icon(Icons.chevron_right_rounded, color: AppColorTokens.textTertiary),
          ]),
        ),
      ),
    );
  }
}
