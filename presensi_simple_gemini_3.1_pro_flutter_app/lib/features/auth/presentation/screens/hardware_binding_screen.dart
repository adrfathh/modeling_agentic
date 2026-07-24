// lib/features/admin_it/presentation/screens/hardware_binding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/features/management/presentation/providers/admin_providers.dart';

class HardwareBindingScreen extends ConsumerWidget {
  const HardwareBindingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(boundDevicesProvider);
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(title: const Text('Hardware Binding')),
      body: devicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColorTokens.activePrimary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (devices) => ListView.builder(
          padding: AppDimensions.screenPadding,
          itemCount: devices.length,
          itemBuilder: (_, i) {
            final d = devices[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColorTokens.surfaceCard,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                boxShadow: AppDimensions.shadowCard,
              ),
              child: Row(children: [
                Icon(Icons.smartphone_rounded, color: d.isActive ? AppColorTokens.attendApprove : AppColorTokens.unavailableGray, size: 28),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d.siswaName, style: AppTextStyles.body2),
                  Text('${d.kelas}  ·  ID: ${d.deviceId.substring(0, 8)}', style: AppTextStyles.label2),
                  Text('Terdaftar ${d.boundAt.day}/${d.boundAt.month}/${d.boundAt.year}', style: AppTextStyles.micro),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: d.isActive ? AppColorTokens.surfaceAttend() : AppColorTokens.unavailableGray.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
                    border: Border.all(color: d.isActive ? AppColorTokens.attendApprove : AppColorTokens.unavailableGray),
                  ),
                  child: Text(d.isActive ? 'ACTIVE' : 'INACTIVE',
                      style: AppTextStyles.statusText(d.isActive ? AppColorTokens.attendApprove : AppColorTokens.unavailableGray).copyWith(fontSize: 10)),
                ),
              ]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColorTokens.activePrimary,
        child: const Icon(Icons.add_rounded, color: AppColorTokens.textOnPrimary),
      ),
    );
  }
}
