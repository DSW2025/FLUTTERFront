import 'package:flutter/material.dart';
import 'package:pakapp/presentation/providers/chat.provider.dart';
import 'package:provider/provider.dart';

class CajaMensaje extends StatelessWidget {
  const CajaMensaje({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focusNode = FocusNode();

    final outlinedInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    );

    final inputDecoration = InputDecoration(
      fillColor: Colors.white,
      enabledBorder: outlinedInputBorder,
      filled: true,
      suffixIcon: IconButton(
        icon: const Icon(Icons.send_rounded),
        onPressed: () {
          final text = textController.text.trim();
          if (text.isEmpty) return;

          context.read<ProvedorChat>().sendMessage(text);
          textController.clear();
          focusNode.requestFocus();
        },
      ),
    );

    return TextFormField(
      controller: textController,
      focusNode: focusNode,
      decoration: inputDecoration,
      onFieldSubmitted: (value) {
        final text = value.trim();
        if (text.isEmpty) return;

        context.read<ProvedorChat>().sendMessage(text);
        textController.clear();
        focusNode.requestFocus();
      },
    );
  }
}
