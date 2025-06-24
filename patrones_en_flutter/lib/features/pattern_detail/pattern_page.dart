// features/pattern_detail/pattern_page.dart
// Muestra toda la información del patrón de diseño recomendado.

import 'package:flutter/material.dart';
import '../../core/models/design_pattern.dart';
import 'widgets/code_viewer.dart';
import '../../shared/widgets/app_scaffold.dart';
import 'package:go_router/go_router.dart';

class PatternPage extends StatelessWidget {
  final DesignPattern pattern;

  const PatternPage({super.key, required this.pattern});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Patrón Recomendado: ${pattern.name}',
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
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
                      onPressed: () => context.go('/tree/0'),
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
}