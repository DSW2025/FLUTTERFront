import 'package:flutter/material.dart';

class BotonIcono extends StatelessWidget {
  final IconData icono;
  final bool seleccionado;
  final VoidCallback onPressed;

  const BotonIcono({
    super.key,
    required this.icono,
    required this.seleccionado,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icono,
        color: seleccionado ? Colors.white : Colors.lightBlueAccent,
        size: seleccionado ? 32 : 24,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
