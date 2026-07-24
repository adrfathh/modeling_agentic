// lib/features/siswa/presentation/screens/barcode_display_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import '../../../../core/security/screen_security.dart';
import '../../../../core/utils/totp_generator.dart';
import 'package:attendance_app/features/attendance/presentation/providers/siswa_providers.dart';

class BarcodeDisplayScreen extends ConsumerStatefulWidget {
  const BarcodeDisplayScreen({super.key});
  @override
  ConsumerState<BarcodeDisplayScreen> createState() => _BarcodeDisplayScreenState();
}

class _BarcodeDisplayScreenState extends ConsumerState<BarcodeDisplayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;
  String _payload = '';
  Timer? _timer;
  int _remaining = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenSecurity.enableSecureWindow();
    });
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _genBarcode();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining--;
        if (_remaining <= 0) _genBarcode();
      });
    });
  }

  void _genBarcode() {
    _payload = TotpBarcodeGenerator.generatePayload(deviceId: 'demo', geoHash: 'demo');
    _remaining = 30;
  }

  @override
  void dispose() {
    ScreenSecurity.disableSecureWindow();
    _pulseCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frozen = ref.watch(freezeStateProvider).valueOrNull ?? false;
    if (frozen) return _freezeScreen();

    final session = ref.watch(currentSessionProvider).valueOrNull;
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(
        title: const Text('Token Presensi'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.lock_rounded, color: AppColorTokens.attendApprove, size: 20),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: AppColorTokens.surfaceCard,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCardHero),
                boxShadow: AppDimensions.shadowCardHover,
              ),
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                if (session != null) ...[
                  Text(session.mapelName, style: AppTextStyles.caption),
                  const SizedBox(height: 2),
                  Text('Jam ke-${session.jamKe}  ·  ${session.jamMulai}–${session.jamSelesai}',
                      style: AppTextStyles.label2),
                  const SizedBox(height: 16),
                  Divider(color: AppColorTokens.divider, height: 1),
                  const SizedBox(height: 16),
                ],
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (ctx, child) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColorTokens.activePrimary.withValues(alpha: _pulse.value),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: child,
                  ),
                  child: QrImageView(
                    data: _payload,
                    size: AppDimensions.barcodeSize,
                    version: QrVersions.auto,
                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColorTokens.textPrimary),
                    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColorTokens.textPrimary),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: AppDimensions.countdownRing,
                  height: AppDimensions.countdownRing,
                  child: Stack(alignment: Alignment.center, children: [
                    CircularProgressIndicator(
                      value: _remaining / 30.0,
                      backgroundColor: AppColorTokens.borderDefault,
                      color: AppColorTokens.activePrimary,
                      strokeWidth: 5,
                    ),
                    Text('$_remaining', style: AppTextStyles.title1),
                  ]),
                ),
                const SizedBox(height: 4),
                Text('detik tersisa', style: AppTextStyles.caption),
              ]),
            ),
            const SizedBox(height: 16),
            Text('🔒 Terlindungi dari tangkapan layar',
                style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('Tunjukkan hanya kepada Guru Mapel-mu',
                style: AppTextStyles.micro, textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  Widget _freezeScreen() => Scaffold(
    backgroundColor: AppColorTokens.waitingFreeze,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.lock_rounded, size: AppDimensions.freezeIconSize, color: AppColorTokens.textOnPrimary),
          const SizedBox(height: 20),
          Text('Akun Terkunci', style: AppTextStyles.display.copyWith(color: AppColorTokens.textOnPrimary)),
          const SizedBox(height: 8),
          Text('Hubungi Admin IT sekolah\nuntuk membuka akun kamu',
            style: AppTextStyles.body1.copyWith(color: AppColorTokens.textOnPrimary.withValues(alpha: 0.85)),
            textAlign: TextAlign.center),
        ]),
      ),
    ),
  );
}
