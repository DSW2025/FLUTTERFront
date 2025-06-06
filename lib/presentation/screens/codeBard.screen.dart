import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pakapp/data/models/detalleCalzado.model.dart';
import 'package:pakapp/data/services/calzado.service.dart';
import 'package:pakapp/presentation/providers/navigator.provider.dart';
import 'package:pakapp/presentation/screens/home.screen.dart';
import 'package:pakapp/presentation/widgets/avatar.widget.dart';
import 'package:pakapp/presentation/widgets/codeBarsCards.widget.dart';
import 'package:provider/provider.dart';

class VistaCodigoBarras extends StatefulWidget {
  const VistaCodigoBarras({super.key});
  @override
  State<VistaCodigoBarras> createState() => _VistaCodigoBarrasState();
}

class _VistaCodigoBarrasState extends State<VistaCodigoBarras> {
  List<CalzadoDetalle> calzados = [];
  MobileScannerController controller = MobileScannerController();
  String? _ultimoCodigo;
  bool _puedeEscanear = true;
  bool _buttonEnable = false;

  void _onDetect(BarcodeCapture capture) async {
    if (!_puedeEscanear) return;

    for (final barcode in capture.barcodes) {
      String? code = barcode.rawValue?.trim();

      // Si tiene 12 dígitos, conviértelo a EAN-13 anteponiendo un 0
      if (code != null && code.length == 12) {
        code = '0$code';
      }

      if (code != null && code != _ultimoCodigo) {
        setState(() {
          _ultimoCodigo = code;
          _puedeEscanear = false;
          _buttonEnable = true;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Código: $code')));

        await Future.delayed(const Duration(seconds: 2));

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
      appBar: AppBar(
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        title: Text('Escanear código de barras'),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VistaHome()),
            );
            context.read<NavigationProvider>().setIndex(0);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Perfil(),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Escáner de fondo
            MobileScanner(controller: controller, onDetect: _onDetect),
            IconButton(
              icon: Icon(Icons.flash_on),
              onPressed: () => controller.toggleTorch(),
            ),
            // Marco del escáner tipo visor
            Align(
              alignment: Alignment.center,
              child: Container(
                width: screenWidth * 0.7,
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Botón flotante y lista de códigos
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _buttonEnable
                              ? const Color(0xFF3B82F6)
                              : Colors.grey.shade600,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed:
                        _buttonEnable
                            ? () async {
                              if (_ultimoCodigo != null) {
                                try {
                                  final codigoLimpio = _ultimoCodigo!.trim();
                                  final detalle =
                                      await CalzadoService.obtenerDatosCalzado(
                                        codigoLimpio,
                                      );
                                  setState(() {
                                    calzados.add(detalle);
                                    _buttonEnable = false;
                                  });
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'error al cargar los datos',
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                            : null,

                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("Añadir código"),
                  ),

                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        child:
                            calzados.isEmpty
                                ? const Text(
                                  'Aún no has agregado ningún código.',
                                  style: TextStyle(color: Colors.white),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: calzados.length,
                                  itemBuilder: (context, index) {
                                    final calzado = calzados[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: CartaCodigoBarras(
                                        calzado: calzado,
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
          ],
        ),
      ),
    );
  }
}
