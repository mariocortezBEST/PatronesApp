// core/providers/theme_provider.dart
// Provider para gestionar el tema de la aplicación (claro, oscuro, automático).
// Persiste la preferencia del usuario usando SharedPreferences.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  AppThemeMode _themeMode = AppThemeMode.system;
  bool _isInitialized = false;

  AppThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;

  // Convierte AppThemeMode a ThemeMode de Flutter
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  // Inicializa el provider cargando la preferencia guardada
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      if (savedTheme != null) {
        _themeMode = AppThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => AppThemeMode.system,
        );
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // Si hay error, usar tema del sistema por defecto
      _themeMode = AppThemeMode.system;
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Cambia el tema y guarda la preferencia
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
    } catch (e) {
      // Silently fail - el tema se aplicará pero no se persistirá
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Métodos de conveniencia para cambiar el tema
  Future<void> setLightMode() => setThemeMode(AppThemeMode.light);
  Future<void> setDarkMode() => setThemeMode(AppThemeMode.dark);
  Future<void> setSystemMode() => setThemeMode(AppThemeMode.system);

  // Toggle entre claro y oscuro (útil para botón de switch)
  Future<void> toggleTheme() async {
    if (_themeMode == AppThemeMode.light) {
      await setDarkMode();
    } else {
      await setLightMode();
    }
  }

  // Obtiene el nombre legible del tema actual
  String get themeName {
    switch (_themeMode) {
      case AppThemeMode.light:
        return 'Claro';
      case AppThemeMode.dark:
        return 'Oscuro';
      case AppThemeMode.system:
        return 'Sistema';
    }
  }

  // Obtiene el icono apropiado para el tema actual
  IconData get themeIcon {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
