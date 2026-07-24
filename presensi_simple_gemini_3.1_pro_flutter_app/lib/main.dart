// lib/main.dart
//
// Application Entry Point
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:attendance_app/core/network/offline_cache.dart';
import 'package:attendance_app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }

  await OfflineCache().init();

  runApp(
    const ProviderScope(
      child: AttendanceApp(),
    ),
  );
}
