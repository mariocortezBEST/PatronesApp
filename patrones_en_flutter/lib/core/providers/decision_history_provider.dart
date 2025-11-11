// core/providers/decision_history_provider.dart
// Provider para gestionar el estado del historial de decisiones.
// Utiliza ChangeNotifier para notificar cambios a los widgets que lo escuchan.
// Opcionalmente persiste el historial usando SharedPreferences.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/decision_history.dart';

class DecisionHistoryProvider extends ChangeNotifier {
  static const String _historyKey = 'decision_history';
  static const String _enablePersistenceKey = 'persist_history';

  final DecisionHistory _history = DecisionHistory();
  bool _persistenceEnabled = false;
  bool _isInitialized = false;

  // Getters para acceder al historial
  DecisionHistory get history => _history;
  int get currentNodeId => _history.currentNodeId;
  bool get canGoBack => _history.canGoBack;
  int get decisionCount => _history.decisionCount;
  bool get persistenceEnabled => _persistenceEnabled;
  bool get isInitialized => _isInitialized;

  // Inicializa el provider cargando configuración y historial guardado
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      // Persistencia habilitada por defecto para guardar progreso automáticamente
      _persistenceEnabled = prefs.getBool(_enablePersistenceKey) ?? true;

      if (_persistenceEnabled) {
        await _loadHistory();
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = true;
      notifyListeners();
      debugPrint('Error initializing history: $e');
    }
  }

  // Habilita o deshabilita la persistencia del historial
  Future<void> setPersistence(bool enabled) async {
    if (_persistenceEnabled == enabled) return;

    _persistenceEnabled = enabled;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_enablePersistenceKey, enabled);

      if (!enabled) {
        // Si se deshabilita, limpiar el historial guardado
        await prefs.remove(_historyKey);
      } else {
        // Si se habilita, guardar el historial actual
        await _saveHistory();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error setting persistence: $e');
    }
  }

  // Navega a un nuevo nodo y notifica a los listeners
  Future<void> navigateToNode(int nodeId, String selectedAnswer) async {
    _history.navigateToNode(nodeId, selectedAnswer);
    notifyListeners();

    if (_persistenceEnabled) {
      await _saveHistory();
    }
  }

  // Retrocede al nodo anterior y notifica a los listeners
  Future<int?> goBack() async {
    final nodeId = _history.goBack();
    if (nodeId != null) {
      notifyListeners();

      if (_persistenceEnabled) {
        await _saveHistory();
      }
    }
    return nodeId;
  }

  // Reinicia el historial y notifica a los listeners
  Future<void> reset() async {
    _history.reset();
    notifyListeners();

    if (_persistenceEnabled) {
      await _clearSavedHistory();
    }
  }

  // Obtiene la respuesta seleccionada para un nodo específico
  String? getAnswerForNode(int nodeId) {
    return _history.getAnswerForNode(nodeId);
  }

  // Obtiene el camino de decisiones tomadas
  List<MapEntry<int, String>> getDecisionPath() {
    return _history.getDecisionPath();
  }

  // Métodos privados para persistencia

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyData = {
        'nodeHistory': _history.nodeHistory,
        'selectedAnswers': _history.selectedAnswers.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      };
      await prefs.setString(_historyKey, jsonEncode(historyData));
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_historyKey);

      if (savedData != null) {
        final historyData = jsonDecode(savedData) as Map<String, dynamic>;
        final nodeHistory = (historyData['nodeHistory'] as List<dynamic>)
            .map((e) => e as int)
            .toList();
        final selectedAnswers = (historyData['selectedAnswers'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value as String));

        // Reconstruir el historial
        _history.reset();
        for (var i = 1; i < nodeHistory.length; i++) {
          final nodeId = nodeHistory[i];
          final prevNodeId = nodeHistory[i - 1];
          final answer = selectedAnswers[prevNodeId];
          if (answer != null) {
            _history.navigateToNode(nodeId, answer);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  Future<void> _clearSavedHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      debugPrint('Error clearing saved history: $e');
    }
  }

  @override
  String toString() {
    return 'DecisionHistoryProvider($_history, persistence: $_persistenceEnabled)';
  }
}
