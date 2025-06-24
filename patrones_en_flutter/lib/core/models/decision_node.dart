// core/models/decision_node.dart
// Modelo de datos para un nodo en el árbol de decisiones.

import 'design_pattern.dart';

// Representa una pregunta, sus posibles respuestas y el resultado (otro nodo o un patrón).
class DecisionNode {
  final int id;
  final String question;
  final Map<String, int> answers; // Clave: Texto de la respuesta, Valor: ID del siguiente nodo
  final DesignPattern? pattern; // Patrón final si este es un nodo hoja

  DecisionNode({
    required this.id,
    required this.question,
    required this.answers,
    this.pattern,
  });

  // Un nodo es hoja si tiene un patrón de diseño asociado.
  bool get isLeaf => pattern != null;
}