import 'package:flutter/material.dart';
import 'package:pakapp/data/models/detalleCalzado.model.dart';

class CartaMejorada extends StatelessWidget {
  final String imagenUrl;
  final String nombre;
  final CalzadoDetalle detalles;

  const CartaMejorada({
    super.key,
    required this.imagenUrl,
    required this.nombre,
    required this.detalles,
  });

  @override
  Widget build(BuildContext context) {
    // Auxiliares para mostrar hasta 4 items y luego "+n"
    List<T> _visibles<T>(List<T> list) => list.take(4).toList();
    int _extra<T>(List<T> list) => list.length - _visibles(list).length;

    final labelStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold);

    return SizedBox(
      width: 200,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // TODO: Navegar a detalle
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1) Imagen con overlay y badge
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Image.network(
                        imagenUrl,
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (ctx, child, prog) =>
                                prog == null
                                    ? child
                                    : const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                        errorBuilder:
                            (_, __, ___) => const Center(
                              child: Icon(Icons.broken_image, size: 48),
                            ),
                      ),
                    ),
                    
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                        child: Text(
                          nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2) Secciones desplazables
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Colores
                        if (detalles.colores.isNotEmpty) ...[
                          Text('Colores', style: labelStyle),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (var c in _visibles(detalles.colores))
                                _buildChip(c['color'] ?? '---'),
                              if (_extra(detalles.colores) > 0)
                                _buildChip('+${_extra(detalles.colores)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Tallas
                        if (detalles.tallas.isNotEmpty) ...[
                          Text('Tallas', style: labelStyle),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (var t in _visibles(detalles.tallas))
                                _buildChip(t['talla'].toString()),
                              if (_extra(detalles.tallas) > 0)
                                _buildChip('+${_extra(detalles.tallas)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Estantes
                        if (detalles.estantes.isNotEmpty) ...[
                          Text('Estantes', style: labelStyle),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (var e in _visibles(detalles.estantes))
                                _buildChip(e['localizacion'] ?? '---'),
                              if (_extra(detalles.estantes) > 0)
                                _buildChip('+${_extra(detalles.estantes)}'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200, width: 0.5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF004D99),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
