import 'package:flutter/material.dart';

class ImagenRelleno extends StatelessWidget {
  final double porcentaje;
  final String url;
  final double alto;
  final double ancho;

  const ImagenRelleno({
    super.key,
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
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(255, 99, 255, 90),
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
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: porcentaje,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(255, 255, 90, 90),
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
