// lib/core/theme/app_dimensions.dart
//
// Spacing, Shape & Component Size System V6 (Bento Grid)
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════

import 'package:flutter/material.dart';

abstract class AppDimensions {
  AppDimensions._();

  // ── SPACING SCALE (base: 8dp) ─────────────────────────────────
  static const double sp2 = 2.0;
  static const double sp4 = 4.0;
  static const double sp8 = 8.0;
  static const double sp12 = 12.0;
  static const double sp16 = 16.0;
  static const double sp20 = 20.0;
  static const double sp24 = 24.0;
  static const double sp32 = 32.0;
  static const double sp48 = 48.0;

  // ── BENTO GRID SPACING ───────────────────────────────────────
  static const double bentoGap = 16.0;
  static const EdgeInsets bentoPadding = EdgeInsets.all(20.0);

  // ── BORDER RADIUS ────────────────────────────────────────────
  static const double radiusBentoLarge = 24.0;
  static const double radiusBentoSmall = 16.0;
  static const double radiusButton = 12.0;
  static const double radiusChip = 999.0;
  static const double radiusInput = 10.0;

  // ── SCREEN PADDING ────────────────────────────────────────────
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(20.0);

  // ── COMPONENT SIZES ──────────────────────────────────────────
  static const double avatarSm = 36.0;
  static const double avatarMd = 44.0;
  static const double avatarLg = 80.0;

  static const double buttonHeight = 52.0;
  static const double buttonHeightSm = 40.0;

  // Timeline
  static const double timelineDotSm = 8.0;
  static const double timelineDotMd = 12.0;
  static const double timelineDotLg = 14.0;
  static const double timelineLineW = 2.0;
  static const double timelineDateW = 48.0;

  static const double tabIndicatorH = 2.0;
  static const double dividerH = 1.0;
  static const double barcodeSize = 220.0;
  static const double countdownRing = 64.0;
  static const double freezeIconSize = 64.0;

  // ── SHADOW ───────────────────────────────────────────────────
  /// Card level 1 (default): subtle shadow, almost flat
  static const List<BoxShadow> shadowBento1 = [
    BoxShadow(
      color: Color(0x08000000), 
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Card level 2 (elevated/interactive/pressed): deeper shadow
  static const List<BoxShadow> shadowBento2 = [
    BoxShadow(
      color: Color(0x14000000), 
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  // Legacy mappings
  static const double radiusCard = radiusBentoSmall;
  static const double radiusCardHero = radiusBentoLarge;
  static const List<BoxShadow> shadowCard = shadowBento1;
  static const List<BoxShadow> shadowCardHover = shadowBento2;
}
