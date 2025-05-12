import 'package:flutter/material.dart';

class Carta extends StatelessWidget {
  final String url;
  final String? nombre;
  final List<dynamic> estantes;

  const Carta(this.url, {this.nombre, required this.estantes, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // imagen desde urñ
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: Image.network(
                url,
                height: 90,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 90,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                nombre ?? 'Sin nombre',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 4),
            Text("Estantes"),
            const SizedBox(height: 4),
            
            Wrap(
              spacing: 2,
              runSpacing: 6,
              children:
                  estantes.map((estante) {
                    final localizacion = estante['localizacion'] ?? '---';
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.shade200,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        localizacion,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF004D99),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
