import 'package:flutter/material.dart';

class IndicadorTiempoModificado extends StatefulWidget {
  final String tiempo;
  const IndicadorTiempoModificado(this.tiempo, {super.key});
  @override
  State<IndicadorTiempoModificado> createState() => _IndicadorTiempoModificadoState();
}

class _IndicadorTiempoModificadoState extends State<IndicadorTiempoModificado> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: Color(0xFF2196F3), size: 18),
          const SizedBox(width: 5),
          Text(
            widget.tiempo,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),

    );
  }
}
