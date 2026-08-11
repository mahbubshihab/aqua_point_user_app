import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Aqua Point Design System — Branded Gradient Presets
abstract class AppGradients {
  /// Primary header gradient (horizontal) — Deep Ocean Blue → Teal
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Primary gradient (vertical) — for tall elements
  static const LinearGradient primaryVertical = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Primary gradient (diagonal) — for cards, backgrounds
  static const LinearGradient primaryDiagonal = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle primary — very light blue gradient for backgrounds
  static const LinearGradient primarySubtle = LinearGradient(
    colors: [Color(0xFFE8F1FF), Color(0xFFE0F7FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient — green tones
  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Warning gradient — amber tones
  static const LinearGradient warning = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Error gradient — red tones
  static const LinearGradient error = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Shimmer gradient — for loading placeholders
  static const LinearGradient shimmer = LinearGradient(
    colors: [
      Color(0xFFE2E8F0),
      Color(0xFFF1F5F9),
      Color(0xFFE2E8F0),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Card highlight gradient — subtle white to transparent overlay
  static const LinearGradient cardHighlight = LinearGradient(
    colors: [Color(0x08000000), Color(0x00000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
