import 'package:flutter/material.dart';

class ImagenRelleno extends StatelessWidget {
  final double porcentaje; // 0.0 a 1.0
  final String url;
  final double alto;
  final double ancho;
  final String? info;
  final int? idEstante;

  const ImagenRelleno(
    this.info, {
    super.key,
    this.idEstante,
    required this.porcentaje,
    required this.url,
    required this.alto,
    required this.ancho,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 1.0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                const Color.fromARGB(255, 99, 255, 90),
                BlendMode.srcATop,
              ),
              child: Image.asset(
                url,
                height: alto,
                width: ancho,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // ocupado
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: porcentaje, // porcentaje ocupado
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                const Color.fromARGB(255, 255, 90, 90),
                BlendMode.srcATop,
              ),
              child: Image.asset(
                url,
                height: alto,
                width: ancho,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
