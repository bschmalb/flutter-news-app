import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeManager({required this.getString, required this.setString, required this.themeKey, this.enabled = true}) {
    _themeMode = _getThemeModeFromLocalStorage();
  }

  final String themeKey;
  final String? Function(String key) getString;
  final Future<void> Function(String key, String value) setString;
  final bool enabled;

  ThemeMode get themeMode => _themeMode;
  late ThemeMode _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }

    return _themeMode == ThemeMode.dark;
  }

  void toggleThemeMode() {
    setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  void setThemeMode(ThemeMode themeMode) {
    if (!enabled || _themeMode == themeMode) return;

    _themeMode = themeMode;
    unawaited(setString(themeKey, themeMode.name));
    notifyListeners();
  }

  ThemeMode _getThemeModeFromLocalStorage() {
    if (!enabled) return ThemeMode.dark;

    final storedThemeMode = getString(themeKey);

    return ThemeMode.values.firstWhere(
      (themeMode) => themeMode.name == storedThemeMode,
      orElse: () => ThemeMode.system,
    );
  }
}
