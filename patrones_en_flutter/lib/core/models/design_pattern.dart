// core/models/design_pattern.dart
// Modelo de datos para un patrón de diseño.

class DesignPattern {
  final String name;
  final String category;
  final String description;
  final String whenToUse;
  final String javaCodeExample;
  final String comparison;

  DesignPattern({
    required this.name,
    required this.category,
    required this.description,
    required this.whenToUse,
    required this.javaCodeExample,
    this.comparison = '',
  });
}