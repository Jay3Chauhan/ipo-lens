import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ipo_lens/utils/consts/app_preference.dart';


class ThemeProvider extends ChangeNotifier {
  final AppPreference _prefs = AppPreference();

  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _themeMode = _parseThemeMode(_prefs.getThemeMode());
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    unawaited(_prefs.setThemeMode(_themeMode.name));
    notifyListeners();
  }
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    unawaited(_prefs.setThemeMode(_themeMode.name));
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
  
    // Navigation
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

}