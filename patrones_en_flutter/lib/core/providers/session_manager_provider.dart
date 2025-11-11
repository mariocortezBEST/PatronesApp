// core/providers/session_manager_provider.dart
// Provider para gestionar múltiples sesiones guardadas de navegación.
// Permite guardar, cargar, eliminar y compartir sesiones.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SessionManagerProvider extends ChangeNotifier {
  static const String _sessionsKey = 'saved_sessions';
  static const int _maxSessions = 20; // Límite de sesiones guardadas

  final Map<String, Session> _sessions = {};
  bool _isInitialized = false;

  // Getters
  Map<String, Session> get sessions => Map.unmodifiable(_sessions);
  List<Session> get sessionsList {
    final list = _sessions.values.toList();
    list.sort((a, b) => (b.lastModified ?? b.createdAt)
        .compareTo(a.lastModified ?? a.createdAt));
    return list;
  }

  bool get isInitialized => _isInitialized;
  int get sessionsCount => _sessions.length;
  bool get hasSessions => _sessions.isNotEmpty;
  bool get canSaveMore => _sessions.length < _maxSessions;

  // Inicializa el provider cargando sesiones guardadas
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_sessionsKey);

      if (savedData != null) {
        final sessionsJson = jsonDecode(savedData) as Map<String, dynamic>;

        _sessions.clear();
        for (final entry in sessionsJson.entries) {
          try {
            final session = Session.fromJson(entry.value as Map<String, dynamic>);
            _sessions[entry.key] = session;
          } catch (e) {
            debugPrint('Error loading session ${entry.key}: $e');
          }
        }
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = true;
      notifyListeners();
      debugPrint('Error initializing sessions: $e');
    }
  }

  // Guarda una nueva sesión
  Future<bool> saveSession(Session session) async {
    if (!canSaveMore && !_sessions.containsKey(session.id)) {
      return false; // Límite alcanzado
    }

    _sessions[session.id] = session;
    notifyListeners();

    return await _persistSessions();
  }

  // Actualiza una sesión existente
  Future<bool> updateSession(Session session) async {
    if (!_sessions.containsKey(session.id)) {
      return false;
    }

    _sessions[session.id] = session.copyWith(
      lastModified: DateTime.now(),
    );
    notifyListeners();

    return await _persistSessions();
  }

  // Elimina una sesión
  Future<bool> deleteSession(String sessionId) async {
    if (!_sessions.containsKey(sessionId)) {
      return false;
    }

    _sessions.remove(sessionId);
    notifyListeners();

    return await _persistSessions();
  }

  // Elimina todas las sesiones
  Future<bool> deleteAllSessions() async {
    if (_sessions.isEmpty) return true;

    _sessions.clear();
    notifyListeners();

    return await _persistSessions();
  }

  // Obtiene una sesión por ID
  Session? getSession(String sessionId) {
    return _sessions[sessionId];
  }

  // Verifica si existe una sesión con ese nombre
  bool sessionNameExists(String name, {String? excludeId}) {
    return _sessions.values.any(
      (session) => session.name == name && session.id != excludeId,
    );
  }

  // Genera un nombre único para una sesión
  String generateUniqueName(String baseName) {
    if (!sessionNameExists(baseName)) {
      return baseName;
    }

    int counter = 1;
    String newName;
    do {
      newName = '$baseName ($counter)';
      counter++;
    } while (sessionNameExists(newName));

    return newName;
  }

  // Exporta una sesión como string
  String exportSession(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) return '';

    return session.toShareableString();
  }

  // Exporta todas las sesiones
  String exportAllSessions() {
    final sessionsJson = _sessions.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    return jsonEncode(sessionsJson);
  }

  // Importa una sesión desde un string
  Future<bool> importSession(String data, {bool autoRename = true}) async {
    try {
      final session = Session.fromShareableString(data);
      if (session == null) return false;

      // Si ya existe una sesión con ese nombre, renombrar
      String finalName = session.name;
      if (autoRename && sessionNameExists(session.name)) {
        finalName = generateUniqueName(session.name);
      }

      final newSession = session.copyWith(
        name: finalName,
        lastModified: DateTime.now(),
      );

      return await saveSession(newSession);
    } catch (e) {
      debugPrint('Error importing session: $e');
      return false;
    }
  }

  // Importa múltiples sesiones
  Future<int> importMultipleSessions(String data) async {
    try {
      final sessionsJson = jsonDecode(data) as Map<String, dynamic>;
      int imported = 0;

      for (final entry in sessionsJson.entries) {
        try {
          final session = Session.fromJson(entry.value as Map<String, dynamic>);
          final success = await importSession(
            session.toShareableString(),
            autoRename: true,
          );
          if (success) imported++;
        } catch (e) {
          debugPrint('Error importing session: $e');
        }
      }

      return imported;
    } catch (e) {
      debugPrint('Error importing multiple sessions: $e');
      return 0;
    }
  }

  // Obtiene estadísticas de las sesiones
  Map<String, dynamic> getStatistics() {
    if (_sessions.isEmpty) {
      return {
        'totalSessions': 0,
        'totalDecisions': 0,
        'averageDecisions': 0.0,
        'mostCommonPattern': null,
      };
    }

    final totalDecisions = _sessions.values
        .fold<int>(0, (sum, session) => sum + session.decisionCount);

    final patternCounts = <String, int>{};
    for (final session in _sessions.values) {
      if (session.resultPatternName != null) {
        patternCounts[session.resultPatternName!] =
            (patternCounts[session.resultPatternName!] ?? 0) + 1;
      }
    }

    String? mostCommonPattern;
    int maxCount = 0;
    patternCounts.forEach((pattern, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonPattern = pattern;
      }
    });

    return {
      'totalSessions': _sessions.length,
      'totalDecisions': totalDecisions,
      'averageDecisions': totalDecisions / _sessions.length,
      'mostCommonPattern': mostCommonPattern,
      'patternCounts': patternCounts,
    };
  }

  // Persiste las sesiones en SharedPreferences
  Future<bool> _persistSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = _sessions.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      await prefs.setString(_sessionsKey, jsonEncode(sessionsJson));
      return true;
    } catch (e) {
      debugPrint('Error persisting sessions: $e');
      return false;
    }
  }

  @override
  String toString() {
    return 'SessionManagerProvider(sessions: ${_sessions.length})';
  }
}
