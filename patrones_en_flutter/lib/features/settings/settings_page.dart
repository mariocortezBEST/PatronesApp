// features/settings/settings_page.dart
// Página de configuración de la aplicación.
// Permite al usuario cambiar el tema, gestionar persistencia del historial, etc.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/decision_history_provider.dart';
import '../../shared/widgets/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Configuración',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Sección de Apariencia
              _buildSectionHeader(context, 'Apariencia'),
              const SizedBox(height: 16),
              _buildThemeSelector(context),
              const SizedBox(height: 32),

              // Sección de Datos
              _buildSectionHeader(context, 'Datos y Privacidad'),
              const SizedBox(height: 16),
              _buildHistoryPersistenceToggle(context),
              const SizedBox(height: 40),

              // Botón para volver
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver al Inicio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      child: Column(
        children: [
          RadioListTile<AppThemeMode>(
            title: const Row(
              children: [
                Icon(Icons.light_mode, size: 20),
                SizedBox(width: 12),
                Text('Claro'),
              ],
            ),
            value: AppThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) => themeProvider.setThemeMode(mode!),
          ),
          const Divider(height: 1),
          RadioListTile<AppThemeMode>(
            title: const Row(
              children: [
                Icon(Icons.dark_mode, size: 20),
                SizedBox(width: 12),
                Text('Oscuro'),
              ],
            ),
            value: AppThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) => themeProvider.setThemeMode(mode!),
          ),
          const Divider(height: 1),
          RadioListTile<AppThemeMode>(
            title: const Row(
              children: [
                Icon(Icons.brightness_auto, size: 20),
                SizedBox(width: 12),
                Text('Automático (Sistema)'),
              ],
            ),
            subtitle: const Text('Sigue la configuración del sistema'),
            value: AppThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) => themeProvider.setThemeMode(mode!),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryPersistenceToggle(BuildContext context) {
    final historyProvider = Provider.of<DecisionHistoryProvider>(context);

    return Card(
      child: SwitchListTile(
        title: const Text('Guardar progreso'),
        subtitle: const Text('Mantiene tu historial de decisiones entre sesiones'),
        value: historyProvider.persistenceEnabled,
        onChanged: (enabled) => historyProvider.setPersistence(enabled),
        secondary: const Icon(Icons.save_outlined),
      ),
    );
  }
}
