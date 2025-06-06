class EstanteModel {
  final int idEstante;
  final String localizacion;
  final int capacidadMaxima;
  final int capacidadOcupada;
  final int? capacidadDisponible;

  EstanteModel({
    required this.idEstante,
    required this.localizacion,
    required this.capacidadMaxima,
    required this.capacidadOcupada,
    this.capacidadDisponible,
  });

  factory EstanteModel.fromJson(Map<String, dynamic> json) {
    return EstanteModel(
      idEstante: json['idEstante'],
      localizacion: json['localizacion'],
      capacidadMaxima: json['capacidadMaxima'],
      capacidadOcupada: json['capacidadOcupada'],
      capacidadDisponible: json['capacidadDisponible'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEstante': idEstante,
      'localizacion': localizacion,
      'capacidadMaxima': capacidadMaxima,
      'capacidadOcupada': capacidadOcupada,
      'capacidadDisponible': capacidadDisponible,
    };
  }
}
