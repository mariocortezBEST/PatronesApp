// main.dart
// Punto de entrada de la aplicación.
// Inicializa Flutter, configura el router y define el tema principal.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'shared/styles/app_theme.dart';
import 'core/providers/decision_history_provider.dart';

void main() {
  runApp(const DesignPatternApp());
}

class DesignPatternApp extends StatelessWidget {
  const DesignPatternApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envolvemos la app con el Provider para gestionar el estado global del historial
    return ChangeNotifierProvider(
      create: (context) => DecisionHistoryProvider(),
      child: MaterialApp.router(
        title: 'Guía de Patrones de Diseño',
        // Usamos AppTheme para mantener la consistencia visual.
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Se adapta al tema del sistema
        debugShowCheckedModeBanner: false,
        // La configuración del router se centraliza en AppRouter.
        routerConfig: AppRouter.router,
      ),
    );
  }
}



















