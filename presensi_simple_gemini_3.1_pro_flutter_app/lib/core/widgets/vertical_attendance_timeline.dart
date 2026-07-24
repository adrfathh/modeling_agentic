// lib/features/shared/widgets/vertical_attendance_timeline.dart
//
// Vertical Attendance Timeline — Most Critical Shared Widget
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// VISUAL REFERENCE: Image 2 — "Adam Sinclair's Attendance"
// Used in 4+ screens across all roles.
//
// Structure: [Date 48dp] [Dot+Line 20dp] [Content flex] [Action 24dp]

import 'package:flutter/material.dart';
import '../../../core/auth/role_model.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';
import 'package:attendance_app/core/theme/status_color_resolver.dart';
import 'package:attendance_app/features/attendance/domain/entities/attendance_timeline_entry.dart';

/// Vertical timeline displaying attendance entries with status indicators.
///
/// Props:
///   entries     : List of [AttendanceTimelineEntry] — sorted by date desc
///   currentRole : UserRole — determines action icon visibility
///   onDeleteTap : Callback — only Admin IT can delete entries
class VerticalAttendanceTimeline extends StatelessWidget {
  final List<AttendanceTimelineEntry> entries;
  final UserRole currentRole;
  final void Function(String entryId)? onDeleteTap;

  const VerticalAttendanceTimeline({
    super.key,
    required this.entries,
    required this.currentRole,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Belum ada data presensi',
            style: AppTextStyles.label2,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      padding: EdgeInsets.zero,
      itemBuilder: (_, i) => _TimelineItem(
        entry: entries[i],
        isLast: i == entries.length - 1,
        showDeleteAction: currentRole == UserRole.adminIT,
        onDeleteTap: onDeleteTap,
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final AttendanceTimelineEntry entry;
  final bool isLast;
  final bool showDeleteAction;
  final void Function(String)? onDeleteTap;

  const _TimelineItem({
    required this.entry,
    required this.isLast,
    required this.showDeleteAction,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusColorResolver.dotColor(entry.status);

    return Stack(
      children: [
        if (!isLast)
          Positioned(
            left: AppDimensions.timelineDateW + 12 + 10 - (AppDimensions.timelineLineW / 2),
            top: 16,
            bottom: 0,
            child: _TimelineConnector(color: color),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── KOLOM TANGGAL ────────────────────── 48dp fixed
            SizedBox(
              width: AppDimensions.timelineDateW,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entry.dayName,
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    entry.date.day.toString().padLeft(2, '0'),
                    style: AppTextStyles.title1,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ── KOLOM DOT ────────── 20dp
            SizedBox(
              width: 20,
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  _TimelineDot(color: color),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ── KOLOM KONTEN ─────────────────────── flex
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label jam pelajaran
                    Text(
                      entry.jamLabel,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 2),
                    // Status label — berwarna
                    Text(
                      StatusColorResolver.statusLabel(entry.status),
                      style: AppTextStyles.statusText(color),
                    ),
                    const SizedBox(height: 2),
                    // Metadata utama (timestamp scan)
                    if (entry.primaryMeta != null)
                      Text(entry.primaryMeta!, style: AppTextStyles.label2),
                    // Metadata sekunder (approved info)
                    if (entry.secondaryMeta != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          entry.secondaryMeta!,
                          style: AppTextStyles.label2.copyWith(
                            color: _resolveSecondaryColor(entry.status),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── IKON AKSI (kanan) ──────────────────── 24dp
            SizedBox(
              width: 24,
              child: _buildActionIcon(entry.status),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIcon(AttendanceStatus status) {
    // Ikon trash → hanya Admin IT, hanya status tertentu
    if (showDeleteAction &&
        (status == AttendanceStatus.hadir ||
            status == AttendanceStatus.alpa ||
            status == AttendanceStatus.izin ||
            status == AttendanceStatus.sakit)) {
      return GestureDetector(
        onTap: () => onDeleteTap?.call(entry.id),
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 20,
            color: AppColorTokens.absentReject.withValues(alpha: 0.6),
          ),
        ),
      );
    }
    // Ikon jam → status Waiting for Approval
    if (status == AttendanceStatus.waiting) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Icon(
          Icons.access_time_rounded,
          size: 20,
          color: AppColorTokens.waitingFreeze,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Color _resolveSecondaryColor(AttendanceStatus status) {
    return status == AttendanceStatus.hadir
        ? AppColorTokens.attendApprove
        : AppColorTokens.textTertiary;
  }
}

class _TimelineDot extends StatelessWidget {
  final Color color;

  const _TimelineDot({required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: AppDimensions.timelineDotMd,
        height: AppDimensions.timelineDotMd,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _TimelineConnector extends StatelessWidget {
  final Color color;

  const _TimelineConnector({required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: AppDimensions.timelineLineW,
        color: color.withValues(alpha: 0.25),
      );
}
