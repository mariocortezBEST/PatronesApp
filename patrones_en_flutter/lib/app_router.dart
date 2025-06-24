import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/home_page.dart';
import 'features/decision_tree/tree_navigator_page.dart';
import 'features/pattern_detail/pattern_page.dart';
import 'core/utils/decision_tree_builder.dart';
import 'core/models/design_pattern.dart';

class AppRouter {
  // El router principal de la aplicación.
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Ruta para la página de inicio.
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      // Ruta para el navegador del árbol de decisiones.
      // El ':nodeId' es un parámetro dinámico que representa el nodo actual.
      GoRoute(
        path: '/tree/:nodeId',
        builder: (context, state) {
          final nodeId = int.tryParse(state.pathParameters['nodeId'] ?? '0') ?? 0;
          return TreeNavigatorPage(nodeId: nodeId);
        },
      ),
      // Ruta para la página de detalles del patrón de diseño.
      // El ':patternName' se usa para encontrar y mostrar el patrón correcto.
      GoRoute(
        path: '/pattern/:patternName',
        builder: (context, state) {
          final patternName = state.pathParameters['patternName'];
          // Buscamos el patrón por su nombre para pasarlo a la página de detalles.
          final pattern = decisionTree.findPatternByName(patternName ?? '');
          
          if (pattern != null) {
            return PatternPage(pattern: pattern);
          } else {
            // Si el patrón no se encuentra, redirigimos a una página de error o al inicio.
            return Scaffold(
              body: Center(
                child: Text('Patrón "$patternName" no encontrado.'),
              ),
            );
          }
        },
      ),
    ],
  );
}