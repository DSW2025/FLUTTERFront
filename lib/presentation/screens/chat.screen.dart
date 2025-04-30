import 'package:flutter/material.dart';
import 'package:pakapp/data/models/message.model.dart';
import 'package:pakapp/presentation/providers/chat.provider.dart';
import 'package:pakapp/presentation/widgets/appBar.widget.dart';
import 'package:pakapp/presentation/widgets/message.widget.dart';
import 'package:pakapp/presentation/widgets/messageBox.wigdet.dart';
import 'package:pakapp/presentation/widgets/navigator.widget.dart';
import 'package:pakapp/presentation/widgets/otherMessage.widget.dart';
import 'package:provider/provider.dart';

class VistaChatBot extends StatefulWidget {
  const VistaChatBot({super.key});

  @override
  State<VistaChatBot> createState() => _VistaChatbotState();
}

class _VistaChatbotState extends State<VistaChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titulo: 'CHATITO'),

      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/wallpapers/wallpaperChatBot.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [Expanded(child: _ChatView()), BarraNavegadora()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provedorChat = context.watch<ProvedorChat>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              controller:
                  provedorChat
                      .chatScrollController, // enlace con el scrollcontroller
              itemCount: provedorChat.listaMensajes.length,
              itemBuilder: (context, index) {
                final mensaje = provedorChat.listaMensajes[index];
                return (mensaje.deQuien == DeQuien.mio)
                    ? MiBurbujaMensaje(mensaje: mensaje)
                    : OtraBurbujaMensaje(mensaje: mensaje);
              },
            ),
          ),
          CajaMensaje(onValue: (value) => provedorChat.sendMessage(value)),
        ],
      ),
    );
  }
}
