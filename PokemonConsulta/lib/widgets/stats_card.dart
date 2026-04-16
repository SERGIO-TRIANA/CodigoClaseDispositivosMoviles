// ============================================================
// WIDGET: StatsCard
// Muestra las estadísticas base con barras animadas
// ============================================================

import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../utils/tipo_colores.dart';

class StatsCard extends StatefulWidget {
  final List<Stat> estadisticas;
  final List<String> tipos;

  const StatsCard({
    super.key,
    required this.estadisticas,
    required this.tipos,
  });

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard>
    with SingleTickerProviderStateMixin {
  // AnimationController controla el ciclo de animación
  late AnimationController _controller;
  // Animation<double> define el valor animado (de 0.0 a 1.0)
  late Animation<double> _animacion;

  @override
  void initState() {
    super.initState();

    // Creamos el controlador con duración de 800ms
    _controller = AnimationController(
      vsync: this, // SingleTickerProviderStateMixin provee el vsync
      duration: const Duration(milliseconds: 800),
    );

    // CurvedAnimation: aplica una curva de aceleración a la animación
    _animacion = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic, // Empieza rápido, frena suave al final
    );

    // Iniciamos la animación al construir el widget
    _controller.forward();
  }

  @override
  void didUpdateWidget(StatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambia el Pokémon, reiniciamos la animación
    if (oldWidget.tipos != widget.tipos) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Siempre limpiar recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = colorDeTipo(
      widget.tipos.isNotEmpty ? widget.tipos.first : 'normal',
    );

    return Card(
      elevation: 8,
      shadowColor: colorPrincipal.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la card
            Text(
              'Estadísticas Base',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorPrincipal,
              ),
            ),
            const SizedBox(height: 16),

            // Generamos una fila por cada estadística
            ...widget.estadisticas.map(
              (stat) => _buildStatRow(stat, colorPrincipal),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Construye una fila de estadística con barra animada ----
  Widget _buildStatRow(Stat stat, Color colorBase) {
    // El máximo posible de una stat en Pokémon es 255
    const double maxStat = 255.0;
    final porcentaje = stat.valor / maxStat;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Nombre de la stat (ancho fijo para que las barras queden alineadas)
          SizedBox(
            width: 100,
            child: Text(
              stat.nombreLegible,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          // Valor numérico
          SizedBox(
            width: 36,
            child: Text(
              '${stat.valor}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // Barra animada (ocupa el espacio restante)
          Expanded(
            child: AnimatedBuilder(
              // AnimatedBuilder reconstruye solo este widget en cada frame
              animation: _animacion,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    // Multiplicamos el porcentaje por la animación (0→1)
                    value: porcentaje * _animacion.value,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Stat.colorPorValor(stat.valor),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
