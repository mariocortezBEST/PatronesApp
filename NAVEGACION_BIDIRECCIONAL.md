# Navegación Bidireccional - Mejora Implementada

## 📋 Resumen

Se ha implementado un sistema completo de **navegación bidireccional** en el árbol de decisiones que permite a los usuarios retroceder en sus decisiones y revisar el camino tomado.

## ✨ Nuevas Funcionalidades

### 1. Historial de Decisiones
- **Seguimiento completo** del camino recorrido por el usuario
- **Almacenamiento de respuestas** seleccionadas en cada nodo
- **Conteo de decisiones** tomadas durante la sesión

### 2. Navegación hacia Atrás
- **Botón de retroceder** visible en la barra de navegación
- Solo aparece cuando hay decisiones previas disponibles
- Restaura el estado del nodo anterior automáticamente

### 3. Reinicio de Historial
- Al presionar "Volver al Inicio" se reinicia el historial
- Al comenzar una nueva guía desde HomePage se limpia el historial anterior
- Garantiza una experiencia limpia en cada sesión

## 🏗️ Arquitectura Implementada

### Nuevos Componentes

#### 1. **DecisionHistory** (`lib/core/models/decision_history.dart`)
Modelo de datos que gestiona:
- Lista de nodos visitados (`_nodeHistory`)
- Mapa de respuestas seleccionadas (`_selectedAnswers`)
- Métodos para navegar hacia adelante y atrás
- Capacidad de reinicio completo

**Métodos principales:**
```dart
void navigateToNode(int nodeId, String selectedAnswer)
int? goBack()
void reset()
List<MapEntry<int, String>> getDecisionPath()
```

#### 2. **DecisionHistoryProvider** (`lib/core/providers/decision_history_provider.dart`)
Provider de estado que:
- Extiende `ChangeNotifier` para notificar cambios
- Gestiona la instancia de `DecisionHistory`
- Notifica a los widgets cuando cambia el estado
- Proporciona acceso reactivo al historial

**Propiedades reactivas:**
```dart
int get currentNodeId
bool get canGoBack
int get decisionCount
```

### Archivos Modificados

#### 1. **pubspec.yaml**
- Agregada dependencia `provider: ^6.1.1`

#### 2. **main.dart**
- Importado `provider` y `DecisionHistoryProvider`
- Envuelto `MaterialApp.router` con `ChangeNotifierProvider`

#### 3. **TreeNavigatorPage**
- Integrado el `DecisionHistoryProvider`
- Agregado botón de retroceder condicional
- Actualización del historial al seleccionar respuestas
- Reinicio del historial al volver al inicio

#### 4. **QuestionWidget**
- Modificado el callback `onAnswerSelected` para pasar tanto el `nodeId` como el `answerText`
- Esto permite guardar la respuesta completa en el historial

#### 5. **HomePage**
- Integrado el provider para reiniciar el historial al comenzar una nueva guía

## 🔄 Flujo de Uso

### Escenario 1: Navegación Normal
```
1. Usuario presiona "Comenzar Guía" → Historial se reinicia
2. Usuario responde pregunta 1 → Se guarda en historial
3. Usuario responde pregunta 2 → Se guarda en historial
4. Usuario responde pregunta 3 → Se guarda en historial
```

### Escenario 2: Navegación con Retroceso
```
1. Usuario está en pregunta 3
2. Usuario presiona botón "←" (retroceder)
3. Sistema muestra pregunta 2
4. Historial se actualiza removiendo la última decisión
5. Usuario puede seleccionar una respuesta diferente
```

### Escenario 3: Reinicio
```
1. Usuario está en cualquier nodo del árbol
2. Usuario presiona "🏠" (inicio)
3. Historial se reinicia completamente
4. Usuario vuelve a la página principal
```

## 🎯 Beneficios de la Implementación

### Para el Usuario
- ✅ **Flexibilidad**: Puede corregir decisiones anteriores sin reiniciar
- ✅ **Exploración**: Puede explorar diferentes caminos del árbol
- ✅ **Confianza**: Sabe que puede retroceder sin perder progreso
- ✅ **UX Mejorada**: Interfaz más intuitiva y menos frustrante

### Para el Código
- ✅ **Separación de Responsabilidades**: Lógica de negocio separada de la UI
- ✅ **Testeable**: Modelo y provider pueden ser testeados unitariamente
- ✅ **Escalable**: Fácil agregar funcionalidades (ej: guardar sesión, mostrar resumen)
- ✅ **Mantenible**: Código organizado siguiendo principios SOLID

## 🧪 Cómo Probar

1. **Ejecutar la aplicación:**
   ```bash
   cd patrones_en_flutter
   flutter pub get
   flutter run
   ```

2. **Probar navegación hacia adelante:**
   - Presiona "Comenzar Guía"
   - Responde 2-3 preguntas
   - Observa que cada pregunta se guarda

3. **Probar navegación hacia atrás:**
   - Presiona el botón de flecha hacia atrás (←)
   - Verifica que vuelves a la pregunta anterior
   - Verifica que puedes seleccionar una respuesta diferente

4. **Probar reinicio:**
   - Presiona el botón de inicio (🏠)
   - Verifica que vuelves a la página principal
   - Comienza de nuevo y verifica que el historial está limpio

## 📊 Posibles Extensiones Futuras

### Alta Prioridad
1. **Resumen del Camino**: Mostrar panel con todas las decisiones tomadas
2. **Persistencia**: Guardar el historial en localStorage/SharedPreferences
3. **Compartir Camino**: Generar URL con el camino de decisiones

### Media Prioridad
4. **Deshacer/Rehacer**: Stack completo de undo/redo
5. **Marcadores**: Guardar puntos específicos del árbol
6. **Analytics**: Registrar qué caminos son más populares

### Baja Prioridad
7. **Visualización del Árbol**: Mostrar gráfico del camino recorrido
8. **Comparación de Caminos**: Explorar múltiples caminos simultáneamente
9. **Modo Tutorial**: Guía paso a paso con hints

## 🐛 Testing Recomendado

### Tests Unitarios
```dart
// Ejemplo de test para DecisionHistory
test('navigateToNode agrega nodo al historial', () {
  final history = DecisionHistory();
  history.navigateToNode(1, 'Respuesta 1');
  expect(history.currentNodeId, 1);
  expect(history.decisionCount, 1);
});

test('goBack retorna al nodo anterior', () {
  final history = DecisionHistory();
  history.navigateToNode(1, 'Respuesta 1');
  history.navigateToNode(2, 'Respuesta 2');
  final previousId = history.goBack();
  expect(previousId, 1);
  expect(history.currentNodeId, 1);
});
```

### Tests de Widget
```dart
// Ejemplo de test para TreeNavigatorPage
testWidgets('Muestra botón de retroceder cuando hay historial', (tester) async {
  // Setup con provider
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => DecisionHistoryProvider(),
      child: MaterialApp(home: TreeNavigatorPage(nodeId: 0)),
    ),
  );

  // Verificar que inicialmente no hay botón de retroceder
  expect(find.byIcon(Icons.arrow_back), findsNothing);
});
```

## 📝 Notas de Implementación

- **Provider elegido sobre otros state management**: Simplicidad y adecuado para el tamaño del proyecto
- **Historial en memoria**: No se persiste entre sesiones (puede agregarse fácilmente)
- **URL-based routing**: go_router mantiene la URL actualizada con el nodo actual
- **Animaciones preservadas**: Las transiciones suaves se mantienen intactas

## 👥 Créditos

Mejora implementada como parte de la evaluación del diseño de la aplicación PatronesApp.
