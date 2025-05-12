class CalzadoEstante {
  final String codigoBarras;
  final int cantidad;

  CalzadoEstante({
    required this.codigoBarras,
    required this.cantidad,
  });

  factory CalzadoEstante.fromJson(Map<String, dynamic> json) {
    return CalzadoEstante(
      codigoBarras: json['codigoBarras'],
      cantidad: json['CalzadoEstante']['cantidad'],
    );
  }
}