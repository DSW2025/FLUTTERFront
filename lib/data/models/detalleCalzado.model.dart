class CalzadoDetalle {
  final String codigoBarras;
  final int idMarca;
  final String modelo;
  final String nombreArchivo;
  final List<dynamic> colores;
  final List<dynamic> tallas;
  final List<dynamic> estantes;
  int cantidad;

  CalzadoDetalle({
    required this.codigoBarras,
    required this.idMarca,
    required this.modelo,
    required this.nombreArchivo,
    required this.colores,
    required this.tallas,
    required this.estantes,
    this.cantidad = 0
  });

  factory CalzadoDetalle.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return CalzadoDetalle(
      codigoBarras: data['codigoBarras'] ?? '',
      idMarca: data['idMarca'] ?? 0,
      modelo: data['modelo'] ?? '',
      nombreArchivo: data['imagen']?['nombreArchivo'] ?? 'default.jpg',
      colores: (data['colores'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      tallas: data['tallas'] is List ? data['tallas'] : [],
      estantes:
          (data['estantes'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList()
              .where((est) => est.containsKey('idEstante'))
              .fold<List<Map<String, dynamic>>>([], (acc, item) {
                final exists = acc.any(
                  (e) => e['idEstante'] == item['idEstante'],
                );
                if (!exists) acc.add(item);
                return acc;
              }) ??
          [],
    );
  }
}
