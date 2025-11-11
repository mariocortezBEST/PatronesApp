// main.dart
// Punto de entrada de la aplicación.
// Inicializa Flutter, configura el router y define el tema principal.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'shared/styles/app_theme.dart';
import 'core/providers/decision_history_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/favorites_provider.dart';
import 'core/providers/session_manager_provider.dart';

void main() async {
  // Aseguramos que los bindings de Flutter estén inicializados antes de acceder a plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos los providers que necesitan datos persistentes
  final themeProvider = ThemeProvider();
  final favoritesProvider = FavoritesProvider();
  final historyProvider = DecisionHistoryProvider();
  final sessionManagerProvider = SessionManagerProvider();

  // Cargamos los datos guardados de forma paralela para mejor performance
  await Future.wait([
    themeProvider.initialize(),
    favoritesProvider.initialize(),
    historyProvider.initialize(),
    sessionManagerProvider.initialize(),
  ]);

  runApp(DesignPatternApp(
    themeProvider: themeProvider,
    favoritesProvider: favoritesProvider,
    historyProvider: historyProvider,
    sessionManagerProvider: sessionManagerProvider,
  ));
}

class DesignPatternApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final FavoritesProvider favoritesProvider;
  final DecisionHistoryProvider historyProvider;
  final SessionManagerProvider sessionManagerProvider;

  const DesignPatternApp({
    super.key,
    required this.themeProvider,
    required this.favoritesProvider,
    required this.historyProvider,
    required this.sessionManagerProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos MultiProvider para gestionar múltiples estados globales
    return MultiProvider(
      providers: [
        // Provider de tema para modo claro/oscuro
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        // Provider de favoritos para guardar patrones
        ChangeNotifierProvider<FavoritesProvider>.value(value: favoritesProvider),
        // Provider de historial de decisiones
        ChangeNotifierProvider<DecisionHistoryProvider>.value(value: historyProvider),
        // Provider de gestión de sesiones guardadas
        ChangeNotifierProvider<SessionManagerProvider>.value(value: sessionManagerProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Guía de Patrones de Diseño',
            // Usamos AppTheme para mantener la consistencia visual
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            // El modo de tema ahora es controlado por ThemeProvider
            themeMode: themeProvider.flutterThemeMode,
            debugShowCheckedModeBanner: false,
            // La configuración del router se centraliza en AppRouter
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}



















