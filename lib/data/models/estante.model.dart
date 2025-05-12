class Estante {
  final int idEstante;
  final String localizacion;
  final int capacidadMaxima;
  final int capacidadOcupada;
  final int capacidadDisponible;

  Estante({
    required this.idEstante,
    required this.localizacion,
    required this.capacidadMaxima,
    required this.capacidadOcupada,
    required this.capacidadDisponible,
  });

  factory Estante.fromJson(Map<String, dynamic> json) {
    return Estante(
      idEstante: json['idEstante'],
      localizacion: json['localizacion'],
      capacidadMaxima: json['capacidadMaxima'],
      capacidadOcupada: json['capacidadOcupada'],
      capacidadDisponible: json['capacidadDisponible'],
    );
  }
}