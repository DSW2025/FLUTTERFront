import 'package:flutter/material.dart';

class CajaMensaje extends StatelessWidget {
  final ValueChanged<String> onValue;
  const CajaMensaje({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focusNode = FocusNode(); // <-- nuevo

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

          onValue(text);
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

        onValue(text);
        textController.clear();
        focusNode.requestFocus();
      },
    );
  }
}
