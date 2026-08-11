import 'package:flutter/material.dart';

/// Aqua Point Design System — "Arctic Ocean" Light Palette
abstract class AppColors {
  // ─── Brand Primary ───
  /// Deep Ocean Blue — CTAs, active states, primary buttons
  static const Color primary = Color(0xFF0066FF);

  /// Sky Blue — light fills, selected backgrounds, chips
  static const Color primaryLight = Color(0xFFE8F1FF);

  /// Dark Blue — pressed states
  static const Color primaryDark = Color(0xFF0047B3);

  // ─── Brand Secondary ───
  /// Ocean Teal — accents, gradient end, highlights
  static const Color secondary = Color(0xFF00B4D8);

  /// Light Teal — secondary fills
  static const Color secondaryLight = Color(0xFFE0F7FA);

  // ─── Backgrounds ───
  /// Snow White scaffold background
  static const Color background = Color(0xFFF8FAFC);

  /// Pure White — cards, sheets, dialogs
  static const Color surface = Color(0xFFFFFFFF);

  /// Slightly tinted surface for nested cards
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // ─── Text ───
  /// Charcoal — headings, primary body text
  static const Color textPrimary = Color(0xFF0F172A);

  /// Slate Gray — subtitles, secondary text
  static const Color textSecondary = Color(0xFF64748B);

  /// Light Gray — placeholders, disabled, hints
  static const Color textTertiary = Color(0xFF94A3B8);

  /// White — text on dark/gradient backgrounds
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Semantic ───
  /// Emerald — success, active, delivered, online
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);

  /// Amber — warning, pending, processing
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);

  /// Rose — error, cancel, delete, destructive
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);

  /// Info Blue — informational badges
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // ─── Borders & Dividers ───
  /// Cool Gray — card borders, input borders
  static const Color border = Color(0xFFE2E8F0);

  /// Very Light — section dividers
  static const Color divider = Color(0xFFF1F5F9);

  // ─── Overlay ───
  /// Scrim for modals/dialogs
  static const Color scrim = Color(0x52000000);

  // ─── Quick Action Colors ───
  static const Color actionBlue = Color(0xFF0066FF);
  static const Color actionGreen = Color(0xFF10B981);
  static const Color actionAmber = Color(0xFFF59E0B);
  static const Color actionPink = Color(0xFFEC4899);
  static const Color actionPurple = Color(0xFF8B5CF6);
  static const Color actionOrange = Color(0xFFF97316);

  // ─── Legacy Aliases (backward compatibility during migration) ───
  static const Color accentCyan = secondary;
  static const Color accentGreen = success;
  static const Color accentGold = warning;
  static const Color accentYellow = warning;
  static const Color accentRed = error;
  static const Color cardBackground = surface;
  static const Color inputFill = surfaceVariant;
  static const Color cardBorder = border;
  static const Color surfaceOverlay = Color(0x0A000000);
}
