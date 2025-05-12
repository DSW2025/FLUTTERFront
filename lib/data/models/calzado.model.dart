class Calzado {
  final String codigoBarras;
  final int idMarca;
  final String modelo;

  Calzado({
    required this.codigoBarras,
    required this.idMarca,
    required this.modelo,
  });

  factory Calzado.fromJson(Map<String, dynamic> json) {
    return Calzado(
      codigoBarras: json['codigoBarras'],
      idMarca: json['idMarca'],
      modelo: json['modelo'],
    );
  }
}
