import 'package:flutter/material.dart';

class HeatmapWidget extends StatelessWidget {
  // Dados de exemplo para o mapa de calor
  final List<List<int>> heatmapData = [
    [0, 1, 2, 3, 4],
    [1, 2, 3, 4, 5],
    [0, 0, 1, 2, 3],
  ];

  HeatmapWidget({super.key});

  // Função para mapear valores para cores
  Color getColor(int value) {
    final colors = [
      Colors.grey[800]!,
      Colors.teal[200]!,
      Colors.teal[400]!,
      Colors.teal[600]!,
      Colors.teal[800]!,
      Colors.teal[900]!,
    ];
    return colors[value.clamp(0, colors.length - 1)];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: heatmapData.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((value) {
              return Container(
                margin: const EdgeInsets.all(2.0),
                width: 20,
                height: 20,
                color: getColor(value),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
