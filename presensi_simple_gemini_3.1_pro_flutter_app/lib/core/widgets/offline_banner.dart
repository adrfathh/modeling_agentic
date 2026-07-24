// lib/features/shared/widgets/offline_banner.dart
//
// Offline Mode Banner
// Zero-Trust Attendance Protocol · SRS-NFR-004
// ═══════════════════════════════════════════════════
// Auto-appears when connectivity is lost.

import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

/// Animated banner indicating offline state or sync progress.
///
/// - Gray (#A0AEC0): Offline, data cached locally
/// - Green (#48BB78): Syncing data back to server
class OfflineBanner extends StatelessWidget {
  final bool isSyncing;
  final int? pendingCount;

  const OfflineBanner({
    super.key,
    this.isSyncing = false,
    this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: isSyncing
          ? AppColorTokens.attendApprove
          : AppColorTokens.unavailableGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSyncing ? Icons.sync_rounded : Icons.wifi_off_rounded,
            color: AppColorTokens.textOnPrimary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            isSyncing
                ? 'Menyinkronkan ${pendingCount ?? ""} data...'
                : 'Offline Mode — Data scan disimpan lokal',
            style: AppTextStyles.caption.copyWith(
              color: AppColorTokens.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
