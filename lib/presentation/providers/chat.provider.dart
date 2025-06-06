import 'package:flutter/material.dart';
import 'package:pakapp/data/models/message.model.dart';
import 'package:pakapp/data/services/assistant.service.dart';

class ProvedorChat extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  List<Mensaje> listaMensajes = [];
  bool escribiendo = false;

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    // Añadir mensaje del usuario
    listaMensajes.add(Mensaje(deQuien: DeQuien.mio, texto: text));
    notifyListeners();
    moveScrolToBottom();

    escribiendo = true;
    notifyListeners();

    try {
      final respuesta = await AssistantService.enviarPregunta(text);
      final textoRespuesta = respuesta['answer'] ?? 'Sin respuesta';
      listaMensajes.add(Mensaje(deQuien: DeQuien.bot, texto: textoRespuesta));
    } catch (_) {
      listaMensajes.add(
        Mensaje(
          deQuien: DeQuien.bot,
          texto: 'Error al obtener respuesta del asistente.',
        ),
      );
    }

    escribiendo = false;
    notifyListeners();
    moveScrolToBottom();
  }

  void moveScrolToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
