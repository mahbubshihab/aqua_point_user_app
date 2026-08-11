import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme provider that manages dark/light mode state,
/// defaulting to the device's system mobile theme if no user preference is saved,
/// and persisting manual user toggles to SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';
  static const String _userOverriddenKey = 'is_theme_overridden';
  
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _initThemePreference();
  }

  Future<void> _initThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final hasUserOverridden = prefs.getBool(_userOverriddenKey) ?? false;

    if (hasUserOverridden) {
      // User manually toggled theme before
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
    } else {
      // Use system mobile default theme!
      final systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = (systemBrightness == Brightness.dark);
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    await prefs.setBool(_userOverriddenKey, true);
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
    await prefs.setBool(_userOverriddenKey, true);
  }
}
