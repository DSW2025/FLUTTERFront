class Mensaje{
  final String texto;
  final DeQuien deQuien;
  Mensaje({required this.texto, required this.deQuien});
}

enum DeQuien {mio, chat}