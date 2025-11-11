// core/models/session.dart
// Modelo para representar una sesión guardada de navegación.
// Incluye el historial completo, metadata y funcionalidad de serialización.

import 'dart:convert';

class Session {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? lastModified;
  final List<int> nodeHistory;
  final Map<int, String> selectedAnswers;
  final String? resultPatternName;
  final int decisionCount;

  Session({
    required this.id,
    required this.name,
    required this.createdAt,
    this.lastModified,
    required this.nodeHistory,
    required this.selectedAnswers,
    this.resultPatternName,
    required this.decisionCount,
  });

  // Crea una sesión desde el historial actual
  factory Session.fromHistory({
    required String name,
    required List<int> nodeHistory,
    required Map<int, String> selectedAnswers,
    String? resultPatternName,
  }) {
    final now = DateTime.now();
    return Session(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: now,
      lastModified: now,
      nodeHistory: List.from(nodeHistory),
      selectedAnswers: Map.from(selectedAnswers),
      resultPatternName: resultPatternName,
      decisionCount: selectedAnswers.length,
    );
  }

  // Serializa a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'nodeHistory': nodeHistory,
      'selectedAnswers': selectedAnswers.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'resultPatternName': resultPatternName,
      'decisionCount': decisionCount,
    };
  }

  // Deserializa desde JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
      nodeHistory: (json['nodeHistory'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      selectedAnswers: (json['selectedAnswers'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value as String)),
      resultPatternName: json['resultPatternName'] as String?,
      decisionCount: json['decisionCount'] as int,
    );
  }

  // Copia con modificaciones
  Session copyWith({
    String? name,
    DateTime? lastModified,
    List<int>? nodeHistory,
    Map<int, String>? selectedAnswers,
    String? resultPatternName,
    int? decisionCount,
  }) {
    return Session(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      lastModified: lastModified ?? this.lastModified,
      nodeHistory: nodeHistory ?? this.nodeHistory,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      resultPatternName: resultPatternName ?? this.resultPatternName,
      decisionCount: decisionCount ?? this.decisionCount,
    );
  }

  // Obtiene una descripción legible de la sesión
  String get description {
    final buffer = StringBuffer();
    buffer.write('$decisionCount decisión${decisionCount != 1 ? 'es' : ''}');

    if (resultPatternName != null) {
      buffer.write(' → $resultPatternName');
    }

    return buffer.toString();
  }

  // Obtiene la fecha formateada
  String get formattedDate {
    final date = lastModified ?? createdAt;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Hace unos momentos';
        }
        return 'Hace ${difference.inMinutes} min';
      }
      return 'Hace ${difference.inHours} hora${difference.inHours != 1 ? 's' : ''}';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Convierte la sesión a string para compartir
  String toShareableString() {
    return jsonEncode(toJson());
  }

  // Crea una sesión desde un string compartido
  static Session? fromShareableString(String data) {
    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      return Session.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'Session(id: $id, name: $name, decisions: $decisionCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Session && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
