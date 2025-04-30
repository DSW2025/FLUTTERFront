import 'package:flutter/material.dart';
import 'package:pakapp/data/models/message.model.dart';

class ProvedorChat extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  List<Mensaje> listaMensajes = [];

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final nuevoMensaje = Mensaje(deQuien: DeQuien.mio, texto: text);
    listaMensajes.add(nuevoMensaje);

    notifyListeners();
    moveScrolToBottom();
  }

  void moveScrolToBottom() {
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
