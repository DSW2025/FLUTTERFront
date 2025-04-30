import 'package:flutter/material.dart';
import 'package:pakapp/data/models/message.model.dart';

class MiBurbujaMensaje extends StatelessWidget {
  final Mensaje mensaje;
  const MiBurbujaMensaje({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 330),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 124, 187, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              mensaje.texto,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
