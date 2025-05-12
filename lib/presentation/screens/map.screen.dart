import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pakapp/data/models/detalleCalzado.model.dart';
import 'package:pakapp/data/models/calzadoEstante.model.dart';
import 'package:pakapp/data/services/calzado.service.dart';
import 'package:pakapp/data/services/estante.service.dart';
import 'package:pakapp/presentation/widgets/appBar.widget.dart';
import 'package:pakapp/presentation/widgets/navigator.widget.dart';
import 'package:pakapp/presentation/widgets/progressContainer.widget.dart';

class VistaMapaEstanterias extends StatefulWidget {
  const VistaMapaEstanterias({super.key});
  @override
  State<VistaMapaEstanterias> createState() => _VistaMapaEstanteriasState();
}

class _VistaMapaEstanteriasState extends State<VistaMapaEstanterias> {
  final String url = 'assets/images/elements/elementShelf.png';
  final double tamano = 100;

  Future<List<ImagenRelleno>> _cargarEstantes() async {
    final estantes = await EstanteService.obtenerEstantes();
    return estantes.map((estante) {
      final porcentaje =
          estante.capacidadMaxima == 0
              ? 0.0
              : estante.capacidadOcupada / estante.capacidadMaxima;

      final texto = """ID: ${estante.idEstante} 
Ubicación: ${estante.localizacion} 
Ocupado: ${estante.capacidadOcupada}
Disponibles: ${estante.capacidadMaxima}""";

      return ImagenRelleno(
        idEstante: estante.idEstante,
        texto,
        porcentaje: porcentaje,
        url: url,
        alto: tamano,
        ancho: tamano,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titulo: 'ESTANTES'),
      body: SafeArea(
        child: FutureBuilder<List<ImagenRelleno>>(
          future: _cargarEstantes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return _MapView(estantes: snapshot.data!);
            }
          },
        ),
      ),
    );
  }
}

class _MapView extends StatefulWidget {
  final List<ImagenRelleno> estantes;
  const _MapView({required this.estantes});
  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  ImagenRelleno? imagenSeleccionada;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/wallpapers/wallpaperShelf2.jpg',
            fit: BoxFit.cover,
          ),
        ),

        Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,

              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 50,
                      bottom: 10,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent.withValues(alpha: 0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Center(
                          child:
                              imagenSeleccionada == null
                                  ? Wrap(
                                    spacing: 20,
                                    runSpacing: 20,
                                    children:
                                        widget.estantes.map((estante) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                imagenSeleccionada = estante;
                                              });
                                            },
                                            child: estante,
                                          );
                                        }).toList(),
                                  )
                                  : imagenSeleccionada!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child:
                  imagenSeleccionada?.info == null
                      ? const SizedBox()
                      : SingleChildScrollView(
                        child: Wrap(
                          children: [
                            // informacion estante
                            Card(
                              elevation: 4,
                              margin: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        imagenSeleccionada!.info!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.6,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        imagenSeleccionada = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // calzados estante
                            if (imagenSeleccionada?.idEstante != null)
                              FutureBuilder<List<CalzadoEstante>>(
                                future:
                                    EstanteService.obtenerCalzadosPorEstante(
                                      imagenSeleccionada!.idEstante!,
                                    ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text("Error: ${snapshot.error}"),
                                    );
                                  } else {
                                    final calzados = snapshot.data!;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...calzados.map(
                                          (calzado) => Card(
                                            elevation: 4,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  10.0,
                                                ),
                                                child: FutureBuilder<
                                                  CalzadoDetalle
                                                >(
                                                  future:
                                                      CalzadoService.obtenerDatosCalzado(
                                                        calzado.codigoBarras,
                                                      ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Text(
                                                        "- ${calzado.codigoBarras} (x${calzado.cantidad})\nCargando detalles...",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                        "- ${calzado.codigoBarras} (x${calzado.cantidad})\nError al cargar detalles",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    } else {
                                                      final detalle =
                                                          snapshot.data!;
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Modelo: ${detalle.modelo}",
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                          Text(
                                                            "[${detalle.codigoBarras}]",
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.grey
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Wrap(
                                                            spacing: 8,
                                                            children:
                                                                detalle.colores.map<
                                                                  Widget
                                                                >((colorObj) {
                                                                  final nombre =
                                                                      colorObj['color'] ??
                                                                      'Desconocido';
                                                                  final color =
                                                                      obtenerColorDesdeNombre(
                                                                        nombre,
                                                                      );
                                                                  return Tooltip(
                                                                    message:
                                                                        nombre,
                                                                    child: Container(
                                                                      width: 24,
                                                                      height:
                                                                          24,
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            color,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              4,
                                                                            ),
                                                                        border: Border.all(
                                                                          color:
                                                                              Colors.black26,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                          ),

                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            "Cantidad: x${calzado.cantidad}",
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
            ),
            BarraNavegadora(),
          ],
        ),
      ],
    );
  }
}

Color obtenerColorDesdeNombre(String nombre) {
  switch (nombre.toLowerCase()) {
    case 'amarillo':
      return Colors.yellow;
    case 'azul':
      return Colors.blue;
    case 'beige':
      return Colors.redAccent;
    case 'blanco':
      return Colors.white;
    case 'cafe':
      return Colors.brown;
    case 'gris':
      return Colors.grey;
    case 'morado':
      return Colors.purple;
    case 'multicolor':
      return Colors.tealAccent;
    case 'naranja':
      return Colors.orange;
    case 'negro':
      return Colors.black;
    case 'plata':
      return Colors.blueGrey;
    case 'rojo':
      return Colors.red;
    case 'rosa':
      return Colors.pink;
    case 'verde':
      return Colors.green;
    case 'crema':
      return Colors.deepOrangeAccent;
    case 'oro':
      return Colors.amber;
    default:
      return Colors.grey.shade300;
  }
}
