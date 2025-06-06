import 'dart:convert';

class CalzadoRelacion {
  final int idCalzadoEstante;
  int? idEstante;
  final int cantidad;
  final String codigoBarras;
  final String modelo;
  final String marca;
  final String color;
  final String talla;
  final int idTalla;
  final int idColor;
  final String? nombreImagen;

  CalzadoRelacion({
    required this.idCalzadoEstante,
    required this.cantidad,
    required this.codigoBarras,
    required this.modelo,
    required this.marca,
    required this.color,
    required this.talla,
    required this.idColor,
    required this.idTalla,
    this.nombreImagen,
    this.idEstante,
  });

  factory CalzadoRelacion.fromJson(Map<String, dynamic> json) {
    final calzado = json['calzado'];
    final color = json['color'];
    final talla = json['talla'];

    return CalzadoRelacion(
      idCalzadoEstante: json['idCalzadoEstante'],
      cantidad: json['cantidad'],
      codigoBarras: calzado?['codigoBarras'] ?? '',
      modelo: calzado?['modelo'] ?? '',
      marca: calzado?['marca']?['marca'] ?? '', 
      color: color?['color'] ?? '',
      talla: talla?['talla'] ?? '',
      idColor: color?['idColor'] ?? 0,
      idTalla: talla?['idTalla'] ?? 0,
    );
  }
}
