// features/pattern_detail/widgets/code_viewer.dart
// Widget para mostrar código con resaltado de sintaxis y botón de copiar.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeViewer extends StatelessWidget {
  final String code;

  const CodeViewer({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2B2B2B) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              code.trim(),
              style: GoogleFonts.firaCode(
                // Un estilo de fuente monoespaciada para código.
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ),
        // Botón de copiar posicionado en la esquina superior derecha.
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Código copiado al portapapeles.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Copiar código',
          ),
        ),
      ],
    );
  }
}