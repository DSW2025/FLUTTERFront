import 'package:flutter/material.dart';
import 'package:pakapp/presentation/widgets/image.widget.dart';
import 'package:pakapp/presentation/widgets/modified.widgets.dart';

class Carta extends StatefulWidget {
  final String url;
  final String? nombre;
  final String? estante;
  final int? cantidad;
  final int? fecha;
  const Carta(
    this.url, {
    this.nombre,
    this.estante,
    this.cantidad,
    this.fecha,
    super.key,
  });
  @override
  State<Carta> createState() => _CartaState();
}

class _CartaState extends State<Carta> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Imagen(url: widget.url, altura: 60, anchura: 120),

            SizedBox(height: 22),

            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(height: 2),
                  children: [
                    TextSpan(
                      text: '${widget.nombre} ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '${widget.estante}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color.fromARGB(255, 67, 67, 67),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  IndicadorTiempoModificado('Mod: ${widget.fecha! < 100 ? widget.fecha : 99}'),
                  SizedBox(width: 20),
                  Text('[${widget.cantidad! < 100 ? widget.cantidad : 99}]'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
