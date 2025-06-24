// features/decision_tree/tree_navigator_page.dart
// Corazón de la herramienta. Muestra la pregunta actual y las opciones.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/decision_node.dart';
import '../../core/utils/decision_tree_builder.dart';
import 'widgets/question_widget.dart';
import '../../shared/widgets/app_scaffold.dart';

class TreeNavigatorPage extends StatelessWidget {
  final int nodeId;

  const TreeNavigatorPage({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    // Obtiene el nodo actual del árbol usando el ID de la URL.
    final DecisionNode? node = decisionTree.getNodeById(nodeId);

    return AppScaffold(
      title: 'Asistente de Decisión',
      // Agregamos un botón para volver al inicio.
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
          tooltip: 'Volver al Inicio',
        )
      ],
      child: Center(
        child: node == null
            // Caso de error: el nodo no existe.
            ? const Text('Error: Nodo no encontrado.')
            // Si el nodo existe, muestra la pregunta.
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: QuestionWidget(
                  key: ValueKey<int>(node.id), // Key para forzar la reconstrucción
                  node: node,
                  onAnswerSelected: (nextNodeId) {
                    final nextNode = decisionTree.getNodeById(nextNodeId);
                    if (nextNode != null) {
                      if (nextNode.isLeaf) {
                        // Si es una hoja, navegamos a la página de detalles del patrón.
                        context.go('/pattern/${nextNode.pattern!.name}');
                      } else {
                        // Si no, navegamos al siguiente nodo de pregunta.
                        context.go('/tree/$nextNodeId');
                      }
                    }
                  },
                ),
              ),
      ),
    );
  }
}