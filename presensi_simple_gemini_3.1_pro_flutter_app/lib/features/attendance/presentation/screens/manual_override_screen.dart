// lib/features/guru_mapel/presentation/screens/manual_override_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/core/theme/status_color_resolver.dart';
import 'package:attendance_app/core/widgets/status_chip.dart';
import 'package:attendance_app/features/attendance/presentation/providers/guru_providers.dart';

class ManualOverrideScreen extends ConsumerStatefulWidget {
  final String siswaId;
  const ManualOverrideScreen({super.key, required this.siswaId});
  @override
  ConsumerState<ManualOverrideScreen> createState() => _ManualOverrideScreenState();
}

class _ManualOverrideScreenState extends ConsumerState<ManualOverrideScreen> {
  AttendanceStatus? _selected;
  final _reasonCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() { _reasonCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(title: const Text('Otorisasi Manual')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: AppDimensions.screenPadding,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Student profile card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColorTokens.surfaceCard,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                boxShadow: AppDimensions.shadowCard,
                border: const Border(left: BorderSide(color: AppColorTokens.activePrimary, width: 4)),
              ),
              child: Row(children: [
                CircleAvatar(radius: 22, backgroundColor: AppColorTokens.activePrimary,
                  child: Text('A', style: AppTextStyles.title1.copyWith(color: AppColorTokens.textOnPrimary))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Ahmad Rizky Pratama', style: AppTextStyles.body2),
                  Text('XI IPA 2  ·  Jam ke-3', style: AppTextStyles.caption),
                ])),
                const StatusChip(status: AttendanceStatus.freeze, size: ChipSize.sm),
              ]),
            ),
            const SizedBox(height: 24),

            // Status selection
            Text('Pilih Status Kehadiran', style: AppTextStyles.label1),
            const SizedBox(height: 12),
            for (final s in [AttendanceStatus.hadir, AttendanceStatus.izin, AttendanceStatus.sakit, AttendanceStatus.alpa])
              _StatusOption(
                status: s,
                label: StatusColorResolver.statusLabel(s),
                isSelected: _selected == s,
                onTap: () => setState(() => _selected = s),
              ),
            const SizedBox(height: 24),

            // Reason
            Text('Deskripsi Kendala Lapangan *', style: AppTextStyles.label1),
            const SizedBox(height: 8),
            TextFormField(
              controller: _reasonCtrl,
              minLines: 3, maxLines: 5, maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Contoh: Gawai siswa rusak, kamera tidak berfungsi...',
              ),
              validator: (v) => (v?.trim().length ?? 0) < 20 ? 'Deskripsi minimal 20 karakter' : null,
            ),
            const SizedBox(height: 16),

            // Auto info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColorTokens.surfaceApp,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColorTokens.borderDefault),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.info_outline_rounded, color: AppColorTokens.activePrimary, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'Koordinat GPS dan UUID perangkat kamu akan\ndicatat otomatis oleh sistem',
                  style: AppTextStyles.caption,
                )),
              ]),
            ),
            const SizedBox(height: 24),

            // Submit
            SizedBox(
              width: double.infinity, height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: (_selected != null && !_loading) ? _submit : null,
                child: _loading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColorTokens.textOnPrimary))
                    : const Text('Konfirmasi Otorisasi'),
              ),
            ),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selected == null) return;
    setState(() => _loading = true);
    final repo = ref.read(guruRepositoryProvider);
    await repo.submitManualOverride(
      siswaId: widget.siswaId, status: _selected!, reason: _reasonCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Otorisasi terkirim, menunggu persetujuan sistem'),
      backgroundColor: AppColorTokens.attendApprove,
    ));
    Navigator.pop(context);
  }
}

class _StatusOption extends StatelessWidget {
  final AttendanceStatus status;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _StatusOption({required this.status, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = StatusColorResolver.dotColor(status);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.10) : AppColorTokens.surfaceCard,
          border: Border.all(color: isSelected ? color : AppColorTokens.borderDefault, width: isSelected ? 1.5 : 1.0),
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        ),
        child: Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(
            shape: BoxShape.circle, color: isSelected ? color : AppColorTokens.borderDefault)),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.body2.copyWith(color: isSelected ? color : AppColorTokens.textSecondary)),
          const Spacer(),
          if (isSelected) Icon(Icons.check_rounded, color: color, size: 18),
        ]),
      ),
    );
  }
}
