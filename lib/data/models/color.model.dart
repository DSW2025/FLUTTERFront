class ColorModel {
  final int idColor;
  final String color;

  ColorModel({
    required this.idColor,
    required this.color,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      idColor: json['idColor'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idColor': idColor,
      'color': color,
    };
  }
}
