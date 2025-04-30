import 'package:flutter/material.dart';

class Imagen extends StatefulWidget {
  final String url;
  final double altura;
  final double anchura;

  const Imagen({
    super.key,
    required this.url,
    required this.altura,
    required this.anchura,
  });

  @override
  State<Imagen> createState() => _ImagenState();
}

class _ImagenState extends State<Imagen> {
  @override
  Widget build(Object context) {
    return Center(
      child: Image.asset(
        widget.url,
        height: widget.altura,
        width: widget.anchura,
        fit: BoxFit.cover, 
      ),
    );
  }
}
