// features/decision_tree/decision_summary_page.dart
// Página que muestra un resumen completo del camino de decisiones tomadas.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/decision_history_provider.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/decision_path_widget.dart';

class DecisionSummaryPage extends StatelessWidget {
  const DecisionSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<DecisionHistoryProvider>(context);
    final decisionPath = historyProvider.getDecisionPath();
    final decisionCount = historyProvider.decisionCount;

    return AppScaffold(
      title: 'Resumen de Decisiones',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header con estadísticas
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Resumen de tu Navegación',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _StatChip(
                              icon: Icons.question_answer,
                              label: 'Decisiones',
                              value: '$decisionCount',
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            _StatChip(
                              icon: Icons.route,
                              label: 'Pasos',
                              value: '${decisionCount + 1}',
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Camino de decisiones
                if (decisionPath.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.explore_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aún no has tomado ninguna decisión',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Comienza la guía para ver tu camino de decisiones aquí.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () => context.go('/'),
                            icon: const Icon(Icons.home),
                            label: const Text('Ir al Inicio'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  DecisionPathWidget(
                    decisionPath: decisionPath,
                  ),

                const SizedBox(height: 32),

                // Botones de acción
                if (decisionPath.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Volver'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: () {
                              historyProvider.reset();
                              context.go('/');
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Comenzar de Nuevo'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Puedes retroceder usando el botón ← en la navegación',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color.withOpacity(0.8),
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
