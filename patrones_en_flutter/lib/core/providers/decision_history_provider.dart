// core/providers/decision_history_provider.dart
// Provider para gestionar el estado del historial de decisiones.
// Utiliza ChangeNotifier para notificar cambios a los widgets que lo escuchan.

import 'package:flutter/foundation.dart';
import '../models/decision_history.dart';

class DecisionHistoryProvider extends ChangeNotifier {
  final DecisionHistory _history = DecisionHistory();

  // Getters para acceder al historial
  DecisionHistory get history => _history;
  int get currentNodeId => _history.currentNodeId;
  bool get canGoBack => _history.canGoBack;
  int get decisionCount => _history.decisionCount;

  // Navega a un nuevo nodo y notifica a los listeners
  void navigateToNode(int nodeId, String selectedAnswer) {
    _history.navigateToNode(nodeId, selectedAnswer);
    notifyListeners();
  }

  // Retrocede al nodo anterior y notifica a los listeners
  int? goBack() {
    final nodeId = _history.goBack();
    if (nodeId != null) {
      notifyListeners();
    }
    return nodeId;
  }

  // Reinicia el historial y notifica a los listeners
  void reset() {
    _history.reset();
    notifyListeners();
  }

  // Obtiene la respuesta seleccionada para un nodo específico
  String? getAnswerForNode(int nodeId) {
    return _history.getAnswerForNode(nodeId);
  }

  // Obtiene el camino de decisiones tomadas
  List<MapEntry<int, String>> getDecisionPath() {
    return _history.getDecisionPath();
  }

  @override
  String toString() {
    return 'DecisionHistoryProvider($_history)';
  }
}
