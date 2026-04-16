// ============================================================
// WIDGET: TipoBadge
// Muestra una pastilla de color con el nombre del tipo
// Ej: [🔥 fire]  [🌪️ flying]
// ============================================================

import 'package:flutter/material.dart';
import '../utils/tipo_colores.dart';

class TipoBadge extends StatelessWidget {
  final String tipo;

  const TipoBadge({super.key, required this.tipo});

  @override
  Widget build(BuildContext context) {
    final color = colorDeTipo(tipo);
    final emoji = tipoEmoji[tipo] ?? '•';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$emoji $tipo',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
