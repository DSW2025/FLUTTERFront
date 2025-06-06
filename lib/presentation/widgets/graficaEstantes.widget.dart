import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficaEstantes extends StatelessWidget {
  /// Mapa de nombre de estante a porcentaje (0.0 - 1.0)
  final Map<String, double> ocupacion;

  const GraficaEstantes({required this.ocupacion, super.key});

  @override
  Widget build(BuildContext context) {
    // Construimos las barras a partir del Map
    final barras =
        ocupacion.entries.toList().asMap().entries.map((e) {
          final idx = e.key;
          final nombre = e.value.key;
          final valor = e.value.value * 100; // fl_chart usa valores numéricos
          return BarChartGroupData(
            x: idx,
            barRods: [BarChartRodData(toY: valor, width: 16)],
            showingTooltipIndicators: [0],
          );
        }).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ocupación por Estante (%)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  minY: 0,
                  groupsSpace: 12,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= ocupacion.length) {
                            return const SizedBox();
                          }
                          final nombre = ocupacion.keys.elementAt(idx);
                          return SideTitleWidget(
                            meta: meta, // <- aquí pasamos todo el TitleMeta
                            space: 4,
                            child: Text(
                              nombre,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: barras,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
