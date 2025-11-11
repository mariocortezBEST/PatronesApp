// shared/widgets/decision_path_widget.dart
// Widget reutilizable para mostrar el camino de decisiones tomadas.

import 'package:flutter/material.dart';

class DecisionPathWidget extends StatelessWidget {
  final List<MapEntry<int, String>> decisionPath;
  final bool isCompact;

  const DecisionPathWidget({
    super.key,
    required this.decisionPath,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (decisionPath.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              const Text('No has tomado ninguna decisión aún.'),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isCompact)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.timeline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tu Camino de Decisiones',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ...decisionPath.asMap().entries.map((entry) {
          final index = entry.key;
          final decision = entry.value;
          final isLast = index == decisionPath.length - 1;

          return _DecisionStepWidget(
            stepNumber: index + 1,
            decision: decision.value,
            isLast: isLast,
            isCompact: isCompact,
          );
        }),
      ],
    );
  }
}

class _DecisionStepWidget extends StatelessWidget {
  final int stepNumber;
  final String decision;
  final bool isLast;
  final bool isCompact;

  const _DecisionStepWidget({
    required this.stepNumber,
    required this.decision,
    required this.isLast,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Línea de tiempo vertical con número
          Column(
            children: [
              // Círculo con número
              Container(
                width: isCompact ? 32 : 40,
                height: isCompact ? 32 : 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Línea vertical conectora (si no es el último)
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Contenido de la decisión
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : (isCompact ? 12 : 16),
              ),
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(isCompact ? 12 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isCompact)
                        Text(
                          'Decisión $stepNumber',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (!isCompact) const SizedBox(height: 8),
                      Text(
                        decision,
                        style: isCompact
                            ? textTheme.bodyMedium
                            : textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
