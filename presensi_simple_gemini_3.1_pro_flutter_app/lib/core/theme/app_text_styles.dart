// lib/core/theme/app_text_styles.dart
//
// Typography System V6 (Bento Grid)
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Using Plus Jakarta Sans per user specification.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';

abstract class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _baseStyle => GoogleFonts.plusJakartaSans(
    color: AppColorTokens.onSurface,
  );

  // ── DISPLAY ───────────────────────────────────────────────────
  /// Large numbers in stat cards (28-32px, bold)
  static TextStyle get display => _baseStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.1,
  );

  // ── HEADING ──────────────────────────────────────────────────
  /// Section titles (20-22px, semibold)
  static TextStyle get heading => _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ── TITLE ─────────────────────────────────────────────────────
  /// Card titles (16-18px, semibold)
  static TextStyle get title => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  // ── BODY ──────────────────────────────────────────────────────
  /// Card content, descriptions (14px, regular)
  static TextStyle get body => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ── CAPTION ───────────────────────────────────────────
  /// Labels, timestamps, metadata (12px, medium)
  static TextStyle get caption => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColorTokens.onSurfaceMuted,
    height: 1.4,
  );

  // ── LEGACY MAPPINGS (Do not remove yet) ──────────────────────
  static TextStyle get headline1 => heading;
  static TextStyle get headline2 => title.copyWith(fontSize: 18);
  static TextStyle get title1 => title;
  static TextStyle get title2 => title.copyWith(fontSize: 15);
  static TextStyle get body1 => body;
  static TextStyle get body2 => body.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get label1 => body.copyWith(fontSize: 13, fontWeight: FontWeight.w600);
  static TextStyle get label2 => caption;
  static TextStyle get micro => caption.copyWith(fontSize: 10);
  
  static TextStyle statusText(Color color) => caption.copyWith(
    fontWeight: FontWeight.w600,
    color: color,
  );
}
