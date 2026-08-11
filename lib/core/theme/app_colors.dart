import 'package:flutter/material.dart';

/// Aqua Point Design System — Dual Theme Palette
/// Static constants for both light and dark modes.
/// The active palette is selected via AppTheme.lightTheme / AppTheme.darkTheme.
abstract class AppColors {
  // ─── Brand Primary (same in both modes) ───
  static const Color primary = Color(0xFF0066FF);
  static const Color primaryLight = Color(0xFFE8F1FF);
  static const Color primaryDark = Color(0xFF0047B3);
  static const Color secondary = Color(0xFF00B4D8);
  static const Color secondaryLight = Color(0xFFE0F7FA);

  // ─── Light Mode Backgrounds ───
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // ─── Light Mode Text ───
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Dark Mode Backgrounds ───
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);

  // ─── Dark Mode Text ───
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // ─── Dark Mode Borders ───
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF1E293B);

  // ─── Semantic (same in both modes) ───
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // ─── Borders & Dividers (Light Mode) ───
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // ─── Overlay ───
  static const Color scrim = Color(0x52000000);

  // ─── Quick Action Colors ───
  static const Color actionBlue = Color(0xFF0066FF);
  static const Color actionGreen = Color(0xFF10B981);
  static const Color actionAmber = Color(0xFFF59E0B);
  static const Color actionPink = Color(0xFFEC4899);
  static const Color actionPurple = Color(0xFF8B5CF6);
  static const Color actionOrange = Color(0xFFF97316);

  // ─── Legacy Aliases ───
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
