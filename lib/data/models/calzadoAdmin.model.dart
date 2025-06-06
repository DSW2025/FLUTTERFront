class CalzadoModel {
  final String codigoBarras;
  final int idMarca;
  final String modelo;
  final double costo;

  CalzadoModel({
    required this.codigoBarras,
    required this.idMarca,
    required this.modelo,
    required this.costo,
  });

  factory CalzadoModel.fromJson(Map<String, dynamic> json) {
    return CalzadoModel(
      codigoBarras: json['codigoBarras'] as String,
      idMarca: json['idMarca'] as int,
      modelo: json['modelo'] as String,
      costo: (json['costo'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoBarras': codigoBarras,
      'idMarca': idMarca,
      'modelo': modelo,
      'costo': costo,
    };
  }
}
