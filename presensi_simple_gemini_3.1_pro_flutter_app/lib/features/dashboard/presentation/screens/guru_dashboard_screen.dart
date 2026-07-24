// lib/features/guru_mapel/presentation/screens/guru_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:attendance_app/router/router.dart';

import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/core/widgets/profile_sidebar.dart';
import 'package:attendance_app/features/attendance/presentation/providers/guru_providers.dart';

class GuruDashboardScreen extends ConsumerWidget {
  const GuruDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(guruDashboardProvider);
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(
        title: const Text('Dashboard Guru'),
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
            // Welcome
            Text('Selamat Datang,', style: AppTextStyles.label2),
            Text(data.guruName, style: AppTextStyles.headline1),
            const SizedBox(height: 4),
            Text('${data.mapelName}  ·  ${data.currentClass}', style: AppTextStyles.label2),
            const SizedBox(height: 20),

            // Geofence Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: data.isInsideGeofence ? AppColorTokens.surfaceAttend() : AppColorTokens.surfaceAbsent(),
                borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                border: Border.all(color: data.isInsideGeofence ? AppColorTokens.attendApprove : AppColorTokens.absentReject),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(data.isInsideGeofence ? Icons.location_on_rounded : Icons.location_off_rounded,
                    size: 16, color: data.isInsideGeofence ? AppColorTokens.attendApprove : AppColorTokens.absentReject),
                const SizedBox(width: 6),
                Text(data.isInsideGeofence ? 'Dalam area sekolah' : 'Di luar area sekolah',
                    style: AppTextStyles.statusText(data.isInsideGeofence ? AppColorTokens.attendApprove : AppColorTokens.absentReject)),
              ]),
            ),
            const SizedBox(height: 20),

            // KPI Cards
            Row(children: [
              _KpiCard(count: data.hadirToday, label: 'Hadir', color: AppColorTokens.attendApprove),
              const SizedBox(width: 10),
              _KpiCard(count: data.alpaToday, label: 'Alpa', color: AppColorTokens.absentReject),
              const SizedBox(width: 10),
              _KpiCard(count: data.waitingCount, label: 'Menunggu', color: AppColorTokens.waitingFreeze),
            ]),
            const SizedBox(height: 24),

            // Quick Actions
            Text('Aksi Cepat', style: AppTextStyles.title1),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Mulai Presensi',
              subtitle: 'Scan barcode siswa',
              color: AppColorTokens.activePrimary,
              onTap: () => context.push(AppRoutes.guruScanner),
            ),
            const SizedBox(height: 8),
            _ActionCard(
              icon: Icons.list_alt_rounded,
              title: 'Daftar Presensi',
              subtitle: 'Lihat rekap kehadiran kelas',
              color: AppColorTokens.attendApprove,
              onTap: () => context.push(AppRoutes.guruAttendance),
            ),
            const SizedBox(height: 8),
            if (data.waitingCount > 0)
              _ActionCard(
                icon: Icons.pending_actions_rounded,
                title: 'Persetujuan (${data.waitingCount})',
                subtitle: 'Entry menunggu validasi',
                color: AppColorTokens.waitingFreeze,
                onTap: () => context.push('/guru/approval/pending_1'),
              ),
          ]),
        ),
      ),
      endDrawer: dashAsync.whenOrNull(
        data: (data) => ProfileSidebar(
          name: data.guruName,
          role: 'Guru Mata Pelajaran',
          subtitle: '${data.mapelName}  ·  ${data.currentClass}',
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _KpiCard({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColorTokens.surfaceCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: AppDimensions.shadowCard,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(height: 8),
          Text('$count', style: AppTextStyles.headline1),
          Text(label, style: AppTextStyles.caption),
        ]),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColorTokens.surfaceCard,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            boxShadow: AppDimensions.shadowCard,
          ),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTextStyles.body2),
              Text(subtitle, style: AppTextStyles.label2),
            ])),
            Icon(Icons.chevron_right_rounded, color: AppColorTokens.textTertiary),
          ]),
        ),
      ),
    );
  }
}
