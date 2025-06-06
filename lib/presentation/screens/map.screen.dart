import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pakapp/presentation/providers/calzadoPorEstante.provider.dart';
import 'package:pakapp/presentation/providers/estante.provider.dart';
import 'package:pakapp/presentation/widgets/appBar.widget.dart';
import 'package:pakapp/presentation/widgets/cardMapShoe.widget.dart';
import 'package:pakapp/presentation/widgets/navigator.widget.dart';
import 'package:pakapp/presentation/widgets/progressContainer.widget.dart';
import 'package:provider/provider.dart';

class VistaMapaEstanterias extends StatefulWidget {
  const VistaMapaEstanterias({super.key});
  @override
  State<VistaMapaEstanterias> createState() => _VistaMapaEstanteriasState();
}

class _VistaMapaEstanteriasState extends State<VistaMapaEstanterias> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EstantesProvider>().cargarEstantes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final estantesProvider = context.watch<EstantesProvider>();
    return Scaffold(
      appBar: MyAppBar(titulo: 'ESTANTES'),
      body: SafeArea(
        child:
            estantesProvider.error != null
                ? Center(child: Text('Error: ${estantesProvider.error}'))
                : (estantesProvider.estantes.isEmpty &&
                    estantesProvider.cargando)
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                  children: [
                    ChangeNotifierProvider(
                      create: (_) => CalzadosPorEstanteProvider(),
                      child: _MapView(estantes: estantesProvider.estantes),
                    ),
                    if (estantesProvider.cargando)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black45,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}

class _MapView extends StatefulWidget {
  final List<EstanteDatos> estantes;
  const _MapView({required this.estantes});
  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  EstanteDatos? imagenSeleccionada;

  void cargarCalzados(int idEstante) {
    context.read<CalzadosPorEstanteProvider>().cargarPorEstante(idEstante);
  }

  @override
  Widget build(BuildContext context) {
    final calzadoProvider = context.watch<CalzadosPorEstanteProvider>();

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
                        color: Colors.transparent.withOpacity(0.2),
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
                                              cargarCalzados(estante.idEstante);
                                            },
                                            child: ImagenRelleno(
                                              porcentaje: estante.porcentaje,
                                              url:
                                                  'assets/images/elements/elementShelf.png',
                                              alto: 100.0,
                                              ancho: 100.0,
                                            ),
                                          );
                                        }).toList(),
                                  )
                                  : ImagenRelleno(
                                    porcentaje: imagenSeleccionada!.porcentaje,
                                    url:
                                        'assets/images/elements/elementShelf.png',
                                    alto: 100.0,
                                    ancho: 100.0,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  imagenSeleccionada == null
                      ? const SizedBox()
                      : SingleChildScrollView(
                        child: Wrap(
                          children: [
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
                                        imagenSeleccionada!.info,
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
                                      context
                                          .read<CalzadosPorEstanteProvider>()
                                          .limpiar();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (calzadoProvider.cargando)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              )
                            else if (calzadoProvider.error != null)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text("Error: ${calzadoProvider.error}"),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    calzadoProvider.calzados.map((calzado) {
                                      calzado.idEstante =
                                          imagenSeleccionada!.idEstante;
                                      return CardMapWidget(calzado: calzado);
                                    }).toList(),
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

  @override
  void didUpdateWidget(covariant _MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.estantes != oldWidget.estantes) {
      if (imagenSeleccionada != null) {
        final matching = widget.estantes.where(
          (e) => e.idEstante == imagenSeleccionada!.idEstante,
        );
        if (matching.isNotEmpty) {
          final updatedEstante = matching.first;
          if (imagenSeleccionada != updatedEstante) {
            setState(() {
              imagenSeleccionada = updatedEstante;
            });
          }
        } else {
          setState(() {
            imagenSeleccionada = null;
          });
          context.read<CalzadosPorEstanteProvider>().limpiar();
        }
      }
    }
  }
}
