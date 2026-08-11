import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme provider that manages dark/light mode state.
/// Real-time response to phone system brightness changes (didChangePlatformBrightness)
/// and saves manual user toggles to SharedPreferences for future app opens.
class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  static const String _themeKey = 'is_dark_mode';
  static const String _userOverriddenKey = 'is_theme_overridden';

  bool _isDarkMode = false;
  bool _hasUserOverridden = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    _initThemePreference();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Listen for real-time mobile phone theme mode changes (Light <-> Dark mode in Android/iOS settings)
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (!_hasUserOverridden) {
      final systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final newIsDark = (systemBrightness == Brightness.dark);
      if (_isDarkMode != newIsDark) {
        _isDarkMode = newIsDark;
        notifyListeners();
      }
    }
  }

  Future<void> _initThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _hasUserOverridden = prefs.getBool(_userOverriddenKey) ?? false;

    if (_hasUserOverridden) {
      // User manually toggled theme before -> restore saved choice from storage
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
    } else {
      // Follow phone system theme default
      final systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = (systemBrightness == Brightness.dark);
    }
    notifyListeners();
  }

  /// Manually toggle theme, save preference to SharedPreferences, and update app UI
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _hasUserOverridden = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    await prefs.setBool(_userOverriddenKey, true);
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    _hasUserOverridden = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
    await prefs.setBool(_userOverriddenKey, true);
  }
}
