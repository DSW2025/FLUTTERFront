class MarcaModel {
  final int idMarca;
  final String marca;

  MarcaModel({
    required this.idMarca,
    required this.marca,
  });

  factory MarcaModel.fromJson(Map<String, dynamic> json) {
    return MarcaModel(
      idMarca: json['idMarca'],
      marca: json['marca'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMarca': idMarca,
      'marca': marca,
    };
  }
}
