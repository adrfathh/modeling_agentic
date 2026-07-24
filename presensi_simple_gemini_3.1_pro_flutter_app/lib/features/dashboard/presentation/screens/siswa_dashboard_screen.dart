// lib/features/siswa/presentation/screens/siswa_dashboard_screen.dart
//
// Siswa Dashboard Screen
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:attendance_app/router/router.dart';
import '../../../../core/auth/role_model.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/core/theme/status_color_resolver.dart';
import 'package:attendance_app/core/widgets/donut_chart_widget.dart';
import 'package:attendance_app/core/widgets/status_chip.dart';
import 'package:attendance_app/core/widgets/vertical_attendance_timeline.dart';
import 'package:attendance_app/core/widgets/profile_sidebar.dart';
import 'package:attendance_app/features/attendance/presentation/providers/siswa_providers.dart';

class SiswaDashboardScreen extends ConsumerWidget {
  const SiswaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(siswaDashboardProvider);

    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(
        title: const Text('Dashboard Siswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            color: AppColorTokens.textTertiary,
            onPressed: () {},
          ),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColorTokens.activePrimary,
          ),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: AppTextStyles.body1),
        ),
        data: (data) => _buildDashboard(context, data),
      ),
      endDrawer: dashboardAsync.whenOrNull(
        data: (data) => ProfileSidebar(
          name: data.profile.name,
          role: 'Siswa',
          subtitle: 'NISN: ${data.profile.nisn}  ·  ${data.profile.kelas}',
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, dynamic data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Freeze Banner ─────────────────────────────
          if (data.isFrozen)
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppColorTokens.waitingFreeze,
                child: Row(
                  children: [
                    const Icon(Icons.lock_rounded,
                        color: AppColorTokens.textOnPrimary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Akun terkunci — Hubungi Admin IT',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColorTokens.textOnPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Profile Card ──────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColorTokens.surfaceCard,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCardHero),
              boxShadow: AppDimensions.shadowCard,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCardHero),
              child: Builder(
                builder: (innerContext) => InkWell(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCardHero),
                  onTap: () {
                    Scaffold.of(innerContext).openEndDrawer();
                  },
                  child: Padding(
                    padding: AppDimensions.cardPaddingLarge,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: AppDimensions.avatarMd / 2,
                          backgroundColor: AppColorTokens.activePrimary,
                          child: Text(
                            data.profile.name.isNotEmpty ? data.profile.name[0].toUpperCase() : '?',
                            style: AppTextStyles.headline2.copyWith(
                              color: AppColorTokens.textOnPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.profile.name, style: AppTextStyles.title1),
                              const SizedBox(height: 2),
                              Text(
                                '${data.profile.kelas}  ·  NISN: ${data.profile.nisn}',
                                style: AppTextStyles.label2,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: AppColorTokens.textTertiary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Active Session Card ───────────────────────
          if (data.currentSession != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ActiveSessionCard(
                session: data.currentSession!,
                isFrozen: data.isFrozen,
                onBarcodeTap: () {
                  if (!data.isFrozen) {
                    GoRouter.of(context).push(AppRoutes.siswaBarcode);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Donut Chart ───────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: AppDimensions.cardPaddingLarge,
              decoration: BoxDecoration(
                color: AppColorTokens.surfaceCard,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusCard),
                boxShadow: AppDimensions.shadowCard,
              ),
              child: DonutChartWidget(
                hadirCount: data.hadirCount,
                terlambatCount: data.terlambatCount,
                izinSakitCount: data.izinSakitCount,
                alpaCount: data.alpaCount,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Timeline Section ──────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Presensi Hari Ini', style: AppTextStyles.title1),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VerticalAttendanceTimeline(
              entries: data.todayEntries,
              currentRole: UserRole.siswa,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ActiveSessionCard extends StatelessWidget {
  final dynamic session;
  final bool isFrozen;
  final VoidCallback onBarcodeTap;

  const _ActiveSessionCard({
    required this.session,
    required this.isFrozen,
    required this.onBarcodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: AppColorTokens.surfaceCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppDimensions.shadowCard,
        border: Border(
          left: BorderSide(
            color: isFrozen
                ? AppColorTokens.waitingFreeze
                : AppColorTokens.activePrimary,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jam Pelajaran Aktif',
                        style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(session.mapelName, style: AppTextStyles.title1),
                    Text(
                      'Jam ke-${session.jamKe}  ·  ${session.jamMulai}–${session.jamSelesai}',
                      style: AppTextStyles.label2,
                    ),
                    Text(session.guruName, style: AppTextStyles.label2),
                  ],
                ),
              ),
              if (!isFrozen)
                StatusChip(
                  status: AttendanceStatus.hadir,
                  size: ChipSize.sm,
                  overrideLabel: 'Aktif',
                ),
              if (isFrozen)
                const StatusChip(
                  status: AttendanceStatus.freeze,
                  size: ChipSize.sm,
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightSm,
            child: ElevatedButton.icon(
              onPressed: isFrozen ? null : onBarcodeTap,
              icon: Icon(
                isFrozen
                    ? Icons.lock_rounded
                    : Icons.qr_code_rounded,
                size: 18,
              ),
              label: Text(
                isFrozen ? 'Barcode Terkunci' : 'Tampilkan Barcode',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFrozen
                    ? AppColorTokens.unavailableGray
                    : AppColorTokens.activePrimary,
                textStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppDimensions.radiusButton),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
