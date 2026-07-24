// lib/features/admin_it/presentation/screens/freeze_management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/features/management/data/repositories/admin_repository.dart';
import 'package:attendance_app/features/management/presentation/providers/admin_providers.dart';

class FreezeManagementScreen extends ConsumerWidget {
  const FreezeManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frozenAsync = ref.watch(frozenStudentsProvider);
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(title: const Text('Manajemen Freeze State')),
      body: frozenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColorTokens.activePrimary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => Column(children: [
          if (list.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColorTokens.surfaceAbsent(),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColorTokens.absentReject),
              ),
              child: Row(children: [
                const Icon(Icons.warning_rounded, color: AppColorTokens.absentReject),
                const SizedBox(width: 8),
                Text('${list.length} gawai siswa dalam status terkunci',
                    style: AppTextStyles.label1.copyWith(color: AppColorTokens.absentReject)),
              ]),
            ),
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: list.length,
            itemBuilder: (_, i) => _FrozenCard(student: list[i], ref: ref),
          )),
        ]),
      ),
    );
  }
}

class _FrozenCard extends StatelessWidget {
  final FrozenStudent student;
  final WidgetRef ref;
  const _FrozenCard({required this.student, required this.ref});

  @override
  Widget build(BuildContext context) {
    final hours = DateTime.now().difference(student.freezeTimestamp).inHours;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorTokens.surfaceCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppDimensions.shadowCard,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 22, backgroundColor: AppColorTokens.waitingFreeze,
            child: Text(student.name[0], style: AppTextStyles.title1.copyWith(color: AppColorTokens.textOnPrimary))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(student.name, style: AppTextStyles.body2),
            Text(student.kelas, style: AppTextStyles.caption),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColorTokens.surfaceAbsent(),
              borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
              border: Border.all(color: AppColorTokens.absentReject),
            ),
            child: Text('FROZEN', style: AppTextStyles.statusText(AppColorTokens.absentReject).copyWith(fontSize: 10)),
          ),
        ]),
        const SizedBox(height: 10),
        Text('Frozen ${hours}h lalu  ·  Gagal biometrik ${student.failCount}x',
            style: AppTextStyles.micro.copyWith(color: AppColorTokens.absentReject)),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, height: 36,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorTokens.attendApprove,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600),
            ),
            onPressed: () => _showUnfreezeDialog(context),
            child: const Text('Unfreeze'),
          ),
        ),
      ]),
    );
  }

  void _showUnfreezeDialog(BuildContext ctx) {
    final reasonCtrl = TextEditingController();
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: Text('Konfirmasi Unfreeze Akun', style: AppTextStyles.title1),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Pastikan kamu sudah:\n✓ Memeriksa identitas siswa secara langsung\n✓ Memverifikasi perangkat fisik gawai siswa\n✓ Mendapatkan alasan kegagalan biometrik',
            style: AppTextStyles.body1),
        const SizedBox(height: 16),
        TextField(controller: reasonCtrl,
          decoration: const InputDecoration(hintText: 'Catatan alasan unfreeze...', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColorTokens.attendApprove),
          onPressed: () async {
            await ref.read(adminRepoProvider).unfreezeStudent(student.id, reasonCtrl.text);
            if (ctx.mounted) {
              Navigator.pop(ctx);
              ref.invalidate(frozenStudentsProvider);
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text('Akun ${student.name} berhasil di-unfreeze'),
                backgroundColor: AppColorTokens.attendApprove,
              ));
            }
          },
          child: const Text('Ya, Unfreeze Sekarang'),
        ),
      ],
    ));
  }
}
