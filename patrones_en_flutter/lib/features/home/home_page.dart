// features/home/home_page.dart
// La página de inicio o "landing page".

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Guía de Patrones de Diseño',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono principal para dar un toque visual
              Icon(
                Icons.account_tree_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              // Título principal
              Text(
                'Encuentra el Patrón de Diseño Correcto',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Descripción
              Text(
                'Responde unas simples preguntas y te guiaremos hacia el patrón de diseño de software que mejor se adapta a tu problema.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botón de llamada a la acción
              FilledButton.tonal(
                onPressed: () {
                  // Navega al primer nodo del árbol de decisiones (ID 0).
                  context.go('/tree/0');
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                child: const Text('Comenzar Guía'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}