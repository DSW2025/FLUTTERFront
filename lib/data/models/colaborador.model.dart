class ColaboradorModel {
  final int idColaborador;
  final String nombres;
  final String? apellidos;
  final String correoElectronico;
  final String rol;

  ColaboradorModel({
    required this.idColaborador,
    required this.nombres,
    this.apellidos,
    required this.correoElectronico,
    required this.rol,
  });

  factory ColaboradorModel.fromJson(Map<String, dynamic> json) {
    return ColaboradorModel(
      idColaborador: json['idColaborador'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      correoElectronico: json['correoElectronico'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idColaborador': idColaborador,
      'nombres': nombres,
      'apellidos': apellidos,
      'correoElectronico': correoElectronico,
      'rol': rol,
    };
  }
}
