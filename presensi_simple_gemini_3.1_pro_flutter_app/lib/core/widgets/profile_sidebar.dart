import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:attendance_app/router/router.dart';
import 'package:attendance_app/core/auth/token_storage.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

class ProfileSidebar extends StatelessWidget {
  final String name;
  final String role;
  final String? subtitle;

  const ProfileSidebar({
    super.key,
    required this.name,
    required this.role,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColorTokens.surfaceApp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Profile
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              color: AppColorTokens.activePrimary.withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(
                  color: AppColorTokens.borderDefault.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColorTokens.activePrimary,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: AppTextStyles.headline1.copyWith(
                      color: AppColorTokens.textOnPrimary,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: AppTextStyles.title1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: AppTextStyles.label1.copyWith(
                    color: AppColorTokens.activePrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption,
                  ),
                ],
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil Saya',
                  onTap: () {
                    Scaffold.of(context).closeEndDrawer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur profil segera hadir')),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  label: 'Pengaturan',
                  onTap: () {
                    Scaffold.of(context).closeEndDrawer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur pengaturan segera hadir')),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Bantuan & Dukungan',
                  onTap: () {
                    Scaffold.of(context).closeEndDrawer();
                  },
                ),
              ],
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              height: AppDimensions.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColorTokens.absentReject,
                ),
                label: const Text(
                  'Keluar',
                  style: TextStyle(
                    color: AppColorTokens.absentReject,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColorTokens.absentReject),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColorTokens.textTertiary),
      title: Text(label, style: AppTextStyles.body2),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Tampilkan dialog konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Konfirmasi Logout', style: AppTextStyles.title1),
        content: Text('Apakah Anda yakin ingin keluar dari sesi ini?', style: AppTextStyles.body2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Batal', style: AppTextStyles.label1),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorTokens.absentReject,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await TokenStorage().clearAll();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }
}
