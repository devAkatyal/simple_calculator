import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_theme.dart';

class ThemeController extends GetxController {
  static const _themeKey = 'isDarkMode';

  // A reactive variable to hold the current theme mode
  final _isDarkMode = false.obs;

  // Getter to expose a boolean whether dark mode is enabled
  bool get isDarkMode => _isDarkMode.value;

  // The current theme data
  ThemeData get theme =>
      _isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme;

  // We call this from main() to ensure the theme is loaded before the UI.
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode.value =
        prefs.getBool(_themeKey) ?? true; // Default to dark mode
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Save the user's preferred theme to SharedPreferences
  Future<void> _saveThemeToPrefs(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // Toggle the theme and save the preference
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToPrefs(_isDarkMode.value);
  }
}
