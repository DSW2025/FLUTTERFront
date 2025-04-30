import 'package:flutter/material.dart';
import 'package:pakapp/data/models/message.model.dart';

class OtraBurbujaMensaje extends StatelessWidget {
  final Mensaje mensaje;

  const OtraBurbujaMensaje({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 330),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 249, 252, 255),
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
