// lib/features/siswa/presentation/screens/biometric_verify_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import '../../../../core/security/screen_security.dart';

class BiometricVerifyScreen extends StatefulWidget {
  const BiometricVerifyScreen({super.key});
  @override
  State<BiometricVerifyScreen> createState() => _BiometricVerifyScreenState();
}

class _BiometricVerifyScreenState extends State<BiometricVerifyScreen>
    with TickerProviderStateMixin {
  int _failCount = 0;
  double _progress = 0.0;
  String _challenge = 'Posisikan wajah di dalam oval';
  _VerifyPhase _phase = _VerifyPhase.activation;
  Timer? _progressTimer;
  late AnimationController _borderColorCtrl;
  late Animation<Color?> _borderColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenSecurity.enableSecureWindow();
    });
    _borderColorCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _borderColor = ColorTween(
      begin: AppColorTokens.absentReject,
      end: AppColorTokens.attendApprove,
    ).animate(CurvedAnimation(parent: _borderColorCtrl, curve: Curves.easeInOut));

    Future.delayed(const Duration(milliseconds: 800), _startLiveness);
  }

  void _startLiveness() {
    if (!mounted) return;
    setState(() {
      _phase = _VerifyPhase.liveness;
      _challenge = 'Kedipkan mata sekali';
      _progress = 0.0;
    });
    _borderColorCtrl.forward();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() { _progress += 0.05 / 3; });
      if (_progress >= 1.0) {
        t.cancel();
        _onVerificationComplete(true);
      }
    });
  }

  void _onVerificationComplete(bool success) {
    _progressTimer?.cancel();
    if (success) {
      setState(() => _phase = _VerifyPhase.success);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      setState(() {
        _failCount++;
        if (_failCount >= 3) {
          _phase = _VerifyPhase.frozen;
        } else {
          _phase = _VerifyPhase.failed;
          Future.delayed(const Duration(seconds: 2), _startLiveness);
        }
      });
    }
  }

  @override
  void dispose() {
    ScreenSecurity.disableSecureWindow();
    _borderColorCtrl.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate to simulate camera
      body: Stack(
        children: [
          // Simulated Full Screen Camera Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.network(
                'https://images.unsplash.com/photo-1550745165-9bc0b252726f', // Placeholder tech background
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const SizedBox(),
              ),
            ),
          ),
          
          // Face oval target in center
          Center(
            child: _buildPhaseContent(),
          ),
          
          // Top Header (Absolute)
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Liveness Detection', style: AppTextStyles.title.copyWith(color: Colors.white)),
                      Text('Posisikan wajah di area target', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Floating Instruction Card at the bottom
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: AppDimensions.bentoPadding,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(AppDimensions.radiusBentoLarge),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                boxShadow: AppDimensions.shadowBento2,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: i < _failCount ? AppColorTokens.error : AppColorTokens.border.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Percobaan $_failCount dari 3',
                    style: AppTextStyles.caption.copyWith(color: Colors.white54),
                  ),
                  const SizedBox(height: 24),
                  
                  if (_phase == _VerifyPhase.liveness)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        color: AppColorTokens.primary,
                        minHeight: 4,
                      ),
                    ),
                  if (_phase == _VerifyPhase.liveness) const SizedBox(height: 16),
                  
                  Text(
                    _challenge,
                    style: AppTextStyles.heading.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseContent() {
    if (_phase == _VerifyPhase.success) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.check_circle_rounded, size: 80, color: AppColorTokens.attendApprove),
        const SizedBox(height: 16),
        Text('Kehadiran Tercatat!',
            style: AppTextStyles.headline1.copyWith(color: AppColorTokens.attendApprove)),
      ]);
    }
    if (_phase == _VerifyPhase.frozen) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.lock_rounded, size: AppDimensions.freezeIconSize, color: AppColorTokens.waitingFreeze),
        const SizedBox(height: 16),
        Text('Akun Terkunci',
            style: AppTextStyles.headline1.copyWith(color: AppColorTokens.waitingFreeze)),
        const SizedBox(height: 8),
        Text('Hubungi Admin IT sekolah',
            style: AppTextStyles.body1.copyWith(color: AppColorTokens.unavailableGray)),
      ]);
    }
    if (_phase == _VerifyPhase.failed) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.cancel_rounded, size: 80, color: AppColorTokens.absentReject),
        const SizedBox(height: 16),
        Text('Verifikasi Gagal',
            style: AppTextStyles.headline2.copyWith(color: AppColorTokens.absentReject)),
        const SizedBox(height: 4),
        Text('Mencoba ulang...',
            style: AppTextStyles.caption.copyWith(color: AppColorTokens.unavailableGray)),
      ]);
    }
    // Liveness / Activation
    return AnimatedBuilder(
      animation: _borderColor,
      builder: (ctx, _) => Container(
        width: 200, height: 260,
        decoration: BoxDecoration(
          border: Border.all(
            color: _borderColor.value ?? AppColorTokens.absentReject,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Icon(Icons.face_rounded, size: 80,
              color: AppColorTokens.textOnPrimary.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}

enum _VerifyPhase { activation, liveness, success, failed, frozen }
