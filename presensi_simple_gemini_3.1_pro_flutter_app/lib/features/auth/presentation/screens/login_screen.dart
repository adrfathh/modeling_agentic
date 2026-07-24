// lib/features/shared/screens/login_screen.dart
//
// Login Screen
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:attendance_app/router/router.dart';
import '../../../../core/auth/role_model.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/security/hardware_binding.dart';
import '../../../../core/network/api_client.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

/// Login screen — entry point for all user roles.
///
/// In production, this connects to the authentication API.
/// Currently provides role-based demo login for development.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // ── Logo & Title ─────────────────────────────────
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColorTokens.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppDimensions.shadowBento2,
                    ),
                    child: const Icon(
                      Icons.fingerprint_rounded,
                      color: AppColorTokens.onPrimary,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'SMA Muhammadiyah\nKasihan',
                  style: AppTextStyles.display.copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Zero-Trust Attendance Protocol',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // ── Login Form Card ──────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: AppColorTokens.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusBentoLarge),
                    boxShadow: AppDimensions.shadowBento1,
                    border: Border.all(color: AppColorTokens.border),
                  ),
                  padding: AppDimensions.bentoPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Email', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Masukkan email sekolah',
                          hintStyle: AppTextStyles.body.copyWith(color: AppColorTokens.onSurfaceMuted),
                          filled: true,
                          fillColor: AppColorTokens.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                            borderSide: BorderSide(color: AppColorTokens.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                            borderSide: BorderSide(color: AppColorTokens.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                            borderSide: const BorderSide(color: AppColorTokens.primary),
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: AppColorTokens.onSurfaceMuted,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Password Field ───────────────────────────────
                      Text('Password', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Masukkan password',
                          hintStyle: AppTextStyles.body.copyWith(color: AppColorTokens.onSurfaceMuted),
                          filled: true,
                          fillColor: AppColorTokens.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                            borderSide: BorderSide(color: AppColorTokens.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                            borderSide: BorderSide(color: AppColorTokens.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                            borderSide: const BorderSide(color: AppColorTokens.primary),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColorTokens.onSurfaceMuted,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColorTokens.onSurfaceMuted,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Login Button ─────────────────────────────────
                      SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorTokens.primary,
                            foregroundColor: AppColorTokens.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColorTokens.onPrimary,
                                  ),
                                )
                              : Text('Masuk', style: AppTextStyles.title.copyWith(color: AppColorTokens.onPrimary)),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),

                // ── Demo Role Buttons ────────────────────────────
                _buildDemoSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppColorTokens.borderDefault)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Demo Login', style: AppTextStyles.caption),
            ),
            Expanded(child: Divider(color: AppColorTokens.borderDefault)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _DemoRoleButton(
                label: 'Admin IT',
                icon: Icons.admin_panel_settings_rounded,
                color: AppColorTokens.activePrimary,
                onTap: () => _demoLogin(UserRole.adminIT),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DemoRoleButton(
                label: 'Guru',
                icon: Icons.school_rounded,
                color: AppColorTokens.attendApprove,
                onTap: () => _demoLogin(UserRole.guru),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DemoRoleButton(
                label: 'Siswa',
                icon: Icons.person_rounded,
                color: AppColorTokens.waitingFreeze,
                onTap: () => _demoLogin(UserRole.siswa),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final response = await ApiClient().post('/auth/login', data: {
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (response.statusCode == 200 && response.data != null) {
        final token = response.data['token'] as String?;
        if (token != null) {
          await TokenStorage().saveTokens(accessToken: token);
          // Normally we'd decode the JWT to get role, for now redirect to general dashboard
          if (mounted) context.go(AppRoutes.siswaDashboard);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _demoLogin(UserRole role) async {
    setState(() => _isLoading = true);

    // For siswa role, fetch the real device ID so hardware binding
    // validation in AuthGuard passes. Other roles don't need it.
    String deviceId = 'demo_device';
    if (role == UserRole.siswa) {
      try {
        deviceId = await HardwareBinding.getCurrentDeviceId();
      } catch (e) {
        debugPrint('HardwareBinding: failed to get device ID — $e');
        // Fallback: use 'demo_device' (will be skipped if null in JWT)
      }
    }

    // Generate a mock JWT with the selected role and device ID
    final mockToken = _generateMockJwt(role, deviceId: deviceId);
    await TokenStorage().saveTokens(accessToken: mockToken);

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to role-specific dashboard
    final route = switch (role) {
      UserRole.adminIT => AppRoutes.adminDashboard,
      UserRole.guru => AppRoutes.guruDashboard,
      UserRole.siswa => AppRoutes.siswaDashboard,
    };
    context.go(route);
  }

  String _generateMockJwt(UserRole role, {required String deviceId}) {
    // Mock JWT for development — 24h expiry
    // In production, this comes from the auth API
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final exp = now + 86400; // 24 hours

    final header = base64Url
        .encode('{"alg":"HS256","typ":"JWT"}'.codeUnits)
        .replaceAll('=', '');
    final payload = base64Url
        .encode(
            '{"userId":"demo_${role.name}","role":"${role.claimValue}","exp":$exp,"deviceId":"$deviceId"}'
                .codeUnits)
        .replaceAll('=', '');
    final signature = base64Url
        .encode('mock_signature'.codeUnits)
        .replaceAll('=', '');

    return '$header.$payload.$signature';
  }
}

class _DemoRoleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DemoRoleButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppDimensions.radiusBentoSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusBentoSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(AppDimensions.radiusBentoSmall),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
