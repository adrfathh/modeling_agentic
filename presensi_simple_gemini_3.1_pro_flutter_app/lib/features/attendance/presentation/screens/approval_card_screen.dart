// lib/features/guru_mapel/presentation/screens/approval_card_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/role_model.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/core/theme/status_color_resolver.dart';
import 'package:attendance_app/core/widgets/status_chip.dart';
import 'package:attendance_app/core/widgets/vertical_attendance_timeline.dart';
import 'package:attendance_app/features/attendance/presentation/providers/guru_providers.dart';

class ApprovalCardScreen extends ConsumerWidget {
  final String entryId;
  const ApprovalCardScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(approvalEntryProvider(entryId));
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(title: const Text('Detail Presensi')),
      body: entryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColorTokens.activePrimary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (entry) => SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Map placeholder
            Container(
              height: 180,
              width: double.infinity,
              color: AppColorTokens.activePrimary.withValues(alpha: 0.08),
              child: Stack(children: [
                Center(child: Icon(Icons.map_rounded, size: 64, color: AppColorTokens.activePrimary.withValues(alpha: 0.3))),
                // Geofence circle placeholder
                Center(child: Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColorTokens.activePrimary.withValues(alpha: 0.3), width: 2),
                    color: AppColorTokens.activePrimary.withValues(alpha: 0.05),
                  ),
                )),
                // Student info overlay
                Positioned(bottom: 0, left: 16, right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColorTokens.surfaceCard,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: AppDimensions.shadowCard,
                    ),
                    child: Row(children: [
                      CircleAvatar(radius: 24, backgroundColor: AppColorTokens.activePrimary,
                        child: Text(entry.siswaName[0], style: AppTextStyles.title1.copyWith(color: AppColorTokens.textOnPrimary))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(entry.siswaName, style: AppTextStyles.title2),
                        Text('${entry.kelas}  ·  ${entry.ruangKelas}', style: AppTextStyles.label2),
                        Text('Jam ke-${entry.jamKe}', style: AppTextStyles.caption),
                      ])),
                    ]),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // Status
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StatusChip(status: entry.status, size: ChipSize.sm)),
            const SizedBox(height: 8),

            // Title
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Presensi Barcode — Jam ke-${entry.jamKe}', style: AppTextStyles.headline2),
                Text('Dibuat otomatis pukul ${entry.timestamp.hour.toString().padLeft(2,"0")}:${entry.timestamp.minute.toString().padLeft(2,"0")} WIB',
                    style: AppTextStyles.label2),
              ])),
            const SizedBox(height: 16),

            // Today's sessions
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Kehadiran Hari Ini', style: AppTextStyles.label1)),
            const SizedBox(height: 8),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                for (int i = 0; i < entry.todaySessions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(child: _SessionCard(session: entry.todaySessions[i])),
                ],
              ])),
            const SizedBox(height: 24),

            // Action Buttons
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Column(children: [
              SizedBox(width: double.infinity, height: AppDimensions.buttonHeight,
                child: OutlinedButton(
                  onPressed: () => _showConfirm(context, 'Yakin tolak presensi ini?', false, ref),
                  child: const Text('TOLAK'),
                )),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => _showConfirm(context, 'Setujui kehadiran siswa ini?', true, ref),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColorTokens.attendApprove),
                  child: const Text('SETUJUI'),
                )),
            ])),
            const SizedBox(height: 24),

            // History timeline
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Riwayat Presensi', style: AppTextStyles.title1)),
            const SizedBox(height: 8),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: VerticalAttendanceTimeline(entries: entry.history, currentRole: UserRole.guru)),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  void _showConfirm(BuildContext ctx, String message, bool isApprove, WidgetRef ref) {
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: Text(isApprove ? 'Setujui' : 'Tolak', style: AppTextStyles.title1),
      content: Text(message, style: AppTextStyles.body1),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: isApprove ? AppColorTokens.attendApprove : AppColorTokens.absentReject),
          onPressed: () async {
            final repo = ref.read(guruRepositoryProvider);
            if (isApprove) { await repo.approveEntry(entryId); } else { await repo.rejectEntry(entryId); }
            if (ctx.mounted) { Navigator.pop(ctx); Navigator.pop(ctx); }
          },
          child: Text(isApprove ? 'Ya, Setujui' : 'Ya, Tolak'),
        ),
      ],
    ));
  }
}

class _SessionCard extends StatelessWidget {
  final dynamic session;
  const _SessionCard({required this.session});
  @override
  Widget build(BuildContext context) {
    final color = StatusColorResolver.dotColor(session.status);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Jam ke-${session.jamKe}', style: AppTextStyles.label1),
        const SizedBox(height: 4),
        Row(children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(session.label, style: AppTextStyles.statusText(color)),
        ]),
      ]),
    );
  }
}
