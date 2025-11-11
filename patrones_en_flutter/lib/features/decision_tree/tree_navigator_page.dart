// features/decision_tree/tree_navigator_page.dart
// Corazón de la herramienta. Muestra la pregunta actual y las opciones.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models/decision_node.dart';
import '../../core/utils/decision_tree_builder.dart';
import '../../core/providers/decision_history_provider.dart';
import 'widgets/question_widget.dart';
import '../../shared/widgets/app_scaffold.dart';

class TreeNavigatorPage extends StatelessWidget {
  final int nodeId;

  const TreeNavigatorPage({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    // Obtiene el nodo actual del árbol usando el ID de la URL.
    final DecisionNode? node = decisionTree.getNodeById(nodeId);
    // Accede al provider del historial de decisiones
    final historyProvider = Provider.of<DecisionHistoryProvider>(context);

    return AppScaffold(
      title: 'Asistente de Decisión',
      // Agregamos botones para retroceder, ver resumen y volver al inicio.
      actions: [
        // Botón de retroceder - solo visible si hay historial
        if (historyProvider.canGoBack)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final previousNodeId = await historyProvider.goBack();
              if (previousNodeId != null) {
                context.go('/tree/$previousNodeId');
              }
            },
            tooltip: 'Retroceder',
          ),
        // Botón de resumen - solo visible si hay decisiones
        if (historyProvider.decisionCount > 0)
          IconButton(
            icon: Badge(
              label: Text('${historyProvider.decisionCount}'),
              child: const Icon(Icons.list_alt),
            ),
            onPressed: () => context.push('/summary'),
            tooltip: 'Ver Resumen',
          ),
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () async {
            // Reiniciamos el historial al volver al inicio
            await historyProvider.reset();
            context.go('/');
          },
          tooltip: 'Volver al Inicio',
        )
      ],
      child: Column(
        children: [
          // Indicador de progreso
          if (historyProvider.decisionCount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.route,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Decisiones tomadas: ${historyProvider.decisionCount}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          // Contenido principal
          Expanded(
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
                        onAnswerSelected: (nextNodeId, answerText) async {
                          final nextNode = decisionTree.getNodeById(nextNodeId);
                          if (nextNode != null) {
                            // Guardamos la decisión en el historial
                            await historyProvider.navigateToNode(nextNodeId, answerText);

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
          ),
        ],
      ),
    );
  }
}