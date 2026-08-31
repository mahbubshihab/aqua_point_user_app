import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme provider that manages light theme state for Aqua Point.
/// Enforces pure Light theme across the entire application.
class ThemeProvider extends ChangeNotifier {
  bool get isDarkMode => false;
  ThemeMode get themeMode => ThemeMode.light;

  ThemeProvider() {
    _initThemePreference();
  }

  Future<void> _initThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', false);
    notifyListeners();
  }

  /// Toggle or set theme kept safely on light mode
  Future<void> toggleTheme() async {
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    notifyListeners();
  }
}
