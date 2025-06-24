// features/decision_tree/result_page.dart
// Este archivo se podría usar en el futuro para una página de transición
// antes de mostrar el resultado final, pero por ahora navegamos directo.
// Se mantiene como placeholder para futuras funcionalidades.

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("¡Hemos encontrado una recomendación para ti!"),
      ),
    );
  }
}