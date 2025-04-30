import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pakapp/data/models/itemCode.model.dart';
import 'package:pakapp/presentation/widgets/codeBarsCards.widget.dart';

class VistaCodigoBarras extends StatefulWidget {
  const VistaCodigoBarras({super.key});
  @override
  State<VistaCodigoBarras> createState() => _VistaCodigoBarrasState();
}

class _VistaCodigoBarrasState extends State<VistaCodigoBarras> {
  List<ItemCodigo> items = [];

  String? _ultimoCodigo;
  bool _puedeEscanear = true;
  bool _buttonEnable = false;

  void _onDetect(BarcodeCapture capture) async {
    if (!_puedeEscanear) return;

    for (final barcode in capture.barcodes) {
      final String? code = barcode.rawValue;

      if (code != null && code != _ultimoCodigo) {
        setState(() {
          _ultimoCodigo = code;
          _puedeEscanear = false;
          _buttonEnable = true;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Código: $code')));
        await Future.delayed(
          const Duration(seconds: 2),
        ); // retraso de 2 segundos
        setState(() {
          _puedeEscanear = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear código de barras')),
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(onDetect: _onDetect),
            Positioned(
              top: screenHeight * 0.15,
              left: 0,
              child: Container(
                height: screenHeight * 0.85,
                width: screenWidth,
                color: Colors.transparent,
                child: Column(
                  spacing: screenHeight * 0.15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_buttonEnable
                                ? Colors.transparent
                                : const Color.fromARGB(255, 8, 0, 255),
                      ),
                      onPressed:
                          _buttonEnable
                              ? () {
                                if (_ultimoCodigo != null) {
                                  setState(() {
                                    items.add(
                                      ItemCodigo(codigo: _ultimoCodigo!),
                                    );
                                    _buttonEnable = false;
                                  });
                                }
                              }
                              : null,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Añadir',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.transparent),
                          constraints: BoxConstraints(
                            maxHeight: screenHeight * 0.4,
                            maxWidth: screenWidth * 0.9,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true, // importante
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: CartaCodigoBarras(
                                  item: items[index],
                                  onChanged: () {
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
