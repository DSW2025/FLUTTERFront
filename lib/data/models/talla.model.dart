class TallaModel {
  final int idTalla;
  final String talla;
  final String? genero;

  TallaModel({
    required this.idTalla,
    required this.talla,
    this.genero,
  });

  factory TallaModel.fromJson(Map<String, dynamic> json) {
    return TallaModel(
      idTalla: json['idTalla'],
      talla: json['talla'],
      genero: json['genero'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTalla': idTalla,
      'talla': talla,
      'genero': genero,
    };
  }
}