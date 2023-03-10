import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    SharedPreferences.getInstance().then((prefs) {
      final themeMode = prefs.getString('themeMode');
      if (themeMode != null) {
        state = ThemeMode.values.firstWhere((e) => e.name == themeMode);
      }
    });
  }

  void setThemeMode(ThemeMode themeMode) {
    state = themeMode;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('themeMode', themeMode.name);
    });
  }
}
