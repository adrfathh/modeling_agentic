// lib/features/shared/screens/device_mismatch_screen.dart
//
// Device Mismatch Error Screen
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Shown when hardware binding validation fails.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:attendance_app/router/router.dart';
import '../../../../core/auth/token_storage.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

/// Device mismatch error screen.
///
/// Displayed when a student's device UUID doesn't match
/// the device bound in their JWT token.
/// Background: #E53E3E (absentReject)
class DeviceMismatchScreen extends StatelessWidget {
  const DeviceMismatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTokens.absentReject,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColorTokens.textOnPrimary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phonelink_erase_rounded,
                  color: AppColorTokens.textOnPrimary,
                  size: 44,
                ),
              ),
              const SizedBox(height: 28),

              // Title
              Text(
                'Perangkat Tidak Dikenali',
                style: AppTextStyles.headline1.copyWith(
                  color: AppColorTokens.textOnPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'Perangkat ini tidak terdaftar untuk akun kamu. '
                'Hubungi Admin IT sekolah untuk mendaftarkan '
                'perangkat baru atau memperbarui binding perangkat.',
                style: AppTextStyles.body1.copyWith(
                  color: AppColorTokens.textOnPrimary.withValues(alpha: 0.85),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Back to login button
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: OutlinedButton(
                  onPressed: () async {
                    await TokenStorage().clearAll();
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColorTokens.textOnPrimary,
                    side: BorderSide(
                      color:
                          AppColorTokens.textOnPrimary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusButton),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Login',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
