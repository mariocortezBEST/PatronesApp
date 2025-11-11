// core/providers/favorites_provider.dart
// Provider para gestionar los patrones de diseño favoritos del usuario.
// Persiste los favoritos usando SharedPreferences.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_patterns';
  final Set<String> _favoritePatternNames = {};
  bool _isInitialized = false;

  Set<String> get favoritePatternNames => Set.unmodifiable(_favoritePatternNames);
  bool get isInitialized => _isInitialized;
  int get favoritesCount => _favoritePatternNames.length;
  bool get hasFavorites => _favoritePatternNames.isNotEmpty;

  // Inicializa el provider cargando los favoritos guardados
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFavorites = prefs.getStringList(_favoritesKey) ?? [];

      _favoritePatternNames.clear();
      _favoritePatternNames.addAll(savedFavorites);

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // Si hay error, empezar con lista vacía
      _favoritePatternNames.clear();
      _isInitialized = true;
      notifyListeners();
      debugPrint('Error loading favorites: $e');
    }
  }

  // Verifica si un patrón es favorito
  bool isFavorite(String patternName) {
    return _favoritePatternNames.contains(patternName);
  }

  // Agrega un patrón a favoritos
  Future<void> addFavorite(String patternName) async {
    if (_favoritePatternNames.contains(patternName)) return;

    _favoritePatternNames.add(patternName);
    notifyListeners();

    await _saveFavorites();
  }

  // Remueve un patrón de favoritos
  Future<void> removeFavorite(String patternName) async {
    if (!_favoritePatternNames.contains(patternName)) return;

    _favoritePatternNames.remove(patternName);
    notifyListeners();

    await _saveFavorites();
  }

  // Toggle del estado de favorito
  Future<void> toggleFavorite(String patternName) async {
    if (isFavorite(patternName)) {
      await removeFavorite(patternName);
    } else {
      await addFavorite(patternName);
    }
  }

  // Limpia todos los favoritos
  Future<void> clearAllFavorites() async {
    if (_favoritePatternNames.isEmpty) return;

    _favoritePatternNames.clear();
    notifyListeners();

    await _saveFavorites();
  }

  // Guarda los favoritos en SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _favoritesKey,
        _favoritePatternNames.toList(),
      );
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  // Obtiene una lista ordenada de los nombres de favoritos
  List<String> getFavoritesList() {
    return _favoritePatternNames.toList()..sort();
  }

  // Importa favoritos desde una lista (útil para migración/backup)
  Future<void> importFavorites(List<String> patternNames) async {
    _favoritePatternNames.clear();
    _favoritePatternNames.addAll(patternNames);
    notifyListeners();

    await _saveFavorites();
  }

  // Exporta favoritos como lista (útil para backup)
  List<String> exportFavorites() {
    return getFavoritesList();
  }
}
