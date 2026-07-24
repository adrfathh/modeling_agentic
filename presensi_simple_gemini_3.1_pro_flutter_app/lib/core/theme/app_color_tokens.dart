// lib/core/theme/app_color_tokens.dart
//
// SINGLE SOURCE OF TRUTH — Color Token System V6 (Bento Grid)
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Modernized color system supporting Light & Dark mode seamlessly.

import 'package:flutter/material.dart';

abstract class AppColorTokens {
  AppColorTokens._();

  // ── BRAND ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF4F46E5); // Modern Indigo
  static const Color primaryContainer = Color(0xFFE0E7FF); // Soft tint
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── SURFACES (Light Mode Default) ──────────────────────────
  static const Color surface = Color(0xFFF8FAFC); // Near-white
  static const Color surfaceElevated = Color(0xFFFFFFFF); // Pure white for cards
  
  // ── TEXT ON SURFACES ───────────────────────────────────────
  static const Color onSurface = Color(0xFF0F172A); // Near-black (Slate 900)
  static const Color onSurfaceMuted = Color(0xFF64748B); // Slate 500

  // ── SEMANTIC STATUS ────────────────────────────────────────
  static const Color success = Color(0xFF10B981); // Emerald 500 (Hadir)
  static const Color successContainer = Color(0xFFD1FAE5);
  
  static const Color warning = Color(0xFFF59E0B); // Amber 500 (Terlambat/Izin)
  static const Color warningContainer = Color(0xFFFEF3C7);
  
  static const Color error = Color(0xFFEF4444); // Red 500 (Alpa/Freeze)
  static const Color errorContainer = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF3B82F6); // Blue 500 (Waiting/Neutral)
  static const Color infoContainer = Color(0xFFDBEAFE);

  // ── ROLE ACCENTS ───────────────────────────────────────────
  static const Color roleSiswa = Color(0xFF3B82F6); // Blue
  static const Color roleGuru = Color(0xFF8B5CF6); // Violet
  static const Color roleAdmin = Color(0xFF14B8A6); // Teal

  // ── BORDERS & DIVIDERS ─────────────────────────────────────
  static const Color border = Color(0xFFE2E8F0); // Slate 200

  // ── LEGACY MAPPINGS (Do not remove yet, to avoid breaking existing code during transition) ─────────
  static const Color activePrimary = primary;
  static const Color attendApprove = success;
  static const Color waitingFreeze = info;
  static const Color absentReject = error;
  static const Color lateSickLeave = warning;
  static const Color unavailableGray = Color(0xFF94A3B8); // Slate 400
  static const Color surfaceApp = surface;
  static const Color surfaceCard = surfaceElevated;
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceMuted;
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textOnPrimary = onPrimary;
  
  static const Color borderDefault = border;
  static const Color borderFocus = primary;
  static const Color divider = Color(0xFFF1F5F9); // Slate 100
  static const Color surfaceHeader = surfaceElevated;
  
  static Color surfaceAttend() => successContainer;
  static Color surfaceWaiting() => infoContainer;
  static Color surfaceAbsent() => errorContainer;
  static Color surfaceLate() => warningContainer;
  static Color surfacePrimary() => primaryContainer;
}
