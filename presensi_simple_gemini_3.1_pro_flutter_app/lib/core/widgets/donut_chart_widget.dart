// lib/features/shared/widgets/donut_chart_widget.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

class DonutChartWidget extends StatelessWidget {
  final int hadirCount;
  final int terlambatCount;
  final int izinSakitCount;
  final int alpaCount;

  const DonutChartWidget({
    super.key,
    required this.hadirCount,
    required this.terlambatCount,
    this.izinSakitCount = 0,
    required this.alpaCount,
  });

  int get totalCount => hadirCount + terlambatCount + izinSakitCount + alpaCount;
  double get percentage =>
      totalCount == 0 ? 0.0 : ((hadirCount + terlambatCount) / totalCount * 100);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140, height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(140, 140),
                painter: _DonutPainter(
                  hadir: hadirCount,
                  terlambat: terlambatCount + izinSakitCount,
                  alpa: alpaCount,
                  total: totalCount,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${percentage.toStringAsFixed(0)}%', style: AppTextStyles.display),
                  Text("Kehadiran\nHari Ini",
                    style: AppTextStyles.micro.copyWith(color: AppColorTokens.textTertiary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: AppColorTokens.attendApprove, label: 'Hadir'),
            const SizedBox(width: 12),
            _LegendItem(color: AppColorTokens.lateSickLeave, label: 'Telat/Izin'),
            const SizedBox(width: 12),
            _LegendItem(color: AppColorTokens.absentReject, label: 'Alpa'),
          ],
        ),
        const SizedBox(height: 8),
        Text('Data menunggu verifikasi tidak dihitung',
          style: AppTextStyles.micro, textAlign: TextAlign.center),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.micro),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final int hadir, terlambat, alpa, total;
  _DonutPainter({required this.hadir, required this.terlambat, required this.alpa, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 16.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.butt;

    if (total == 0) {
      paint.color = AppColorTokens.borderDefault;
      canvas.drawArc(rect, 0, 2 * math.pi, false, paint);
      return;
    }

    const gap = 0.04;
    final totalAngle = 2 * math.pi;
    var startAngle = -math.pi / 2;

    for (final (count, color) in [(hadir, AppColorTokens.attendApprove), (terlambat, AppColorTokens.lateSickLeave), (alpa, AppColorTokens.absentReject)]) {
      if (count <= 0) continue;
      final sweep = (count / total) * totalAngle - gap;
      if (sweep <= 0) continue;
      paint.color = color;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      hadir != old.hadir || terlambat != old.terlambat || alpa != old.alpa;
}
