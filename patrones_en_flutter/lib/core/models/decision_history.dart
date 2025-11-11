// core/models/decision_history.dart
// Modelo para rastrear el historial de navegación en el árbol de decisiones.
// Permite al usuario navegar hacia adelante y atrás en sus elecciones.

class DecisionHistory {
  // Lista de IDs de nodos visitados en orden cronológico
  final List<int> _nodeHistory;

  // Mapa que relaciona el ID del nodo con la respuesta seleccionada
  final Map<int, String> _selectedAnswers;

  DecisionHistory()
      : _nodeHistory = [0], // Iniciamos en el nodo raíz (0)
        _selectedAnswers = {};

  // Getters para acceso de solo lectura
  List<int> get nodeHistory => List.unmodifiable(_nodeHistory);
  Map<int, String> get selectedAnswers => Map.unmodifiable(_selectedAnswers);

  // Obtiene el ID del nodo actual (el último en el historial)
  int get currentNodeId => _nodeHistory.isNotEmpty ? _nodeHistory.last : 0;

  // Verifica si podemos navegar hacia atrás
  bool get canGoBack => _nodeHistory.length > 1;

  // Obtiene la cantidad de decisiones tomadas
  int get decisionCount => _nodeHistory.length - 1;

  // Avanza a un nuevo nodo, guardando la respuesta seleccionada
  void navigateToNode(int nodeId, String selectedAnswer) {
    if (_nodeHistory.isNotEmpty) {
      _selectedAnswers[_nodeHistory.last] = selectedAnswer;
    }
    _nodeHistory.add(nodeId);
  }

  // Retrocede al nodo anterior
  int? goBack() {
    if (canGoBack) {
      // Removemos el nodo actual
      final removedNode = _nodeHistory.removeLast();

      // Removemos la respuesta asociada al nodo previo
      if (_nodeHistory.isNotEmpty) {
        _selectedAnswers.remove(_nodeHistory.last);
      }

      return currentNodeId;
    }
    return null;
  }

  // Reinicia el historial al inicio
  void reset() {
    _nodeHistory.clear();
    _nodeHistory.add(0); // Volvemos al nodo raíz
    _selectedAnswers.clear();
  }

  // Obtiene la respuesta seleccionada para un nodo específico
  String? getAnswerForNode(int nodeId) {
    return _selectedAnswers[nodeId];
  }

  // Obtiene un resumen del camino recorrido
  List<MapEntry<int, String>> getDecisionPath() {
    return _selectedAnswers.entries.toList();
  }

  @override
  String toString() {
    return 'DecisionHistory(nodes: $_nodeHistory, answers: $_selectedAnswers)';
  }
}
