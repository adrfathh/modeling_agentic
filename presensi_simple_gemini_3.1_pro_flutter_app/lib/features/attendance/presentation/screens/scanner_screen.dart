// lib/features/guru_mapel/presentation/screens/scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _geofenceChecked = false;
  bool _insideGeofence = false;

  @override
  void initState() {
    super.initState();
    _checkGeofence();
  }

  Future<void> _checkGeofence() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() { _geofenceChecked = true; _insideGeofence = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColorTokens.textOnPrimary,
        title: const Text('Scan Barcode Siswa'),
      ),
      body: !_geofenceChecked
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const CircularProgressIndicator(color: AppColorTokens.activePrimary),
              const SizedBox(height: 16),
              Text('Memeriksa lokasi GPS...', style: AppTextStyles.body1.copyWith(color: AppColorTokens.textOnPrimary)),
            ]))
          : !_insideGeofence
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.location_off_rounded, size: 64, color: AppColorTokens.absentReject),
                  const SizedBox(height: 16),
                  Text('Di Luar Area Sekolah', style: AppTextStyles.headline2.copyWith(color: AppColorTokens.absentReject)),
                  const SizedBox(height: 8),
                  Text('Scanner hanya aktif dalam radius 100m dari sekolah',
                      style: AppTextStyles.body1.copyWith(color: AppColorTokens.unavailableGray), textAlign: TextAlign.center),
                ]))
              : Stack(children: [
                  // Camera placeholder
                  Container(color: const Color(0xFF1A1A1A)),
                  Center(child: Container(
                    width: 250, height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColorTokens.activePrimary, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Icon(Icons.qr_code_scanner_rounded,
                        size: 64, color: AppColorTokens.activePrimary.withValues(alpha: 0.5))),
                  )),
                  // Bottom info
                  Positioned(bottom: 48, left: 24, right: 24,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColorTokens.surfaceCard.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                      ),
                      child: Column(children: [
                        Row(children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: AppColorTokens.attendApprove),
                          const SizedBox(width: 6),
                          Text('Dalam area sekolah', style: AppTextStyles.statusText(AppColorTokens.attendApprove)),
                        ]),
                        const SizedBox(height: 8),
                        Text('Arahkan kamera ke barcode siswa', style: AppTextStyles.body1),
                      ]),
                    ),
                  ),
                ]),
    );
  }
}
