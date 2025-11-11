// features/pattern_detail/pattern_page.dart
// Muestra toda la información del patrón de diseño recomendado.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/design_pattern.dart';
import '../../core/providers/decision_history_provider.dart';
import 'widgets/code_viewer.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/decision_path_widget.dart';
import 'package:go_router/go_router.dart';

class PatternPage extends StatelessWidget {
  final DesignPattern pattern;

  const PatternPage({super.key, required this.pattern});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<DecisionHistoryProvider>(context);
    final decisionPath = historyProvider.getDecisionPath();

    return AppScaffold(
      title: 'Patrón Recomendado: ${pattern.name}',
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            historyProvider.reset();
            context.go('/');
          },
          tooltip: 'Volver al Inicio',
        )
      ],
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  // Sección del camino recorrido
                  if (decisionPath.isNotEmpty) ...[
                    _buildDecisionPathSection(context, decisionPath),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 32),
                  ],

                  _buildSection(context, '¿Qué es?', pattern.description),
                  const SizedBox(height: 24),
                  _buildSection(context, '¿Cuándo usarlo?', pattern.whenToUse),
                  const SizedBox(height: 24),
                   _buildSection(context, 'Comparación', pattern.comparison),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Ejemplo en Java'),
                  const SizedBox(height: 16),
                  CodeViewer(code: pattern.javaCodeExample),
                  const SizedBox(height: 40),
                  Center(
                    child: FilledButton.icon(
                      onPressed: () {
                        historyProvider.reset();
                        context.go('/tree/0');
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Empezar de Nuevo'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pattern.category.toUpperCase(),
          style: textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          pattern.name,
          style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
        ),
      ],
    );
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDecisionPathSection(
      BuildContext context, List<MapEntry<int, String>> decisionPath) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Patrón Encontrado!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Este es el camino que seguiste para llegar aquí:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DecisionPathWidget(
              decisionPath: decisionPath,
              isCompact: true,
            ),
          ],
        ),
      ),
    );
  }
}