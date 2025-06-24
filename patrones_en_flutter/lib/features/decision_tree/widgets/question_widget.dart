// features/decision_tree/widgets/question_widget.dart
// Widget reutilizable para mostrar una pregunta y sus respuestas.

import 'package:flutter/material.dart';
import '../../../core/models/decision_node.dart';

class QuestionWidget extends StatelessWidget {
  final DecisionNode node;
  final Function(int) onAnswerSelected;

  const QuestionWidget({
    super.key,
    required this.node,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Muestra el número de la pregunta/paso
          Text(
            'Paso ${node.id + 1}',
            style: textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // La pregunta en sí
          Text(
            node.question,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Genera una lista de botones para cada respuesta.
          ...node.answers.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: OutlinedButton(
                onPressed: () => onAnswerSelected(entry.value),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(entry.key, textAlign: TextAlign.center),
              ),
            );
          }),
        ],
      ),
    );
  }
}