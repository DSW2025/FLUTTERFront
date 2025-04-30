import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pakapp/presentation/widgets/appBar.widget.dart';
import 'package:pakapp/presentation/widgets/navigator.widget.dart';
import 'package:pakapp/presentation/widgets/progressContainer.widget.dart';

class VistaMapaEstanterias extends StatefulWidget {
  const VistaMapaEstanterias({super.key});
  @override
  State<VistaMapaEstanterias> createState() => _VistaMapaEstanteriasState();
}

class _VistaMapaEstanteriasState extends State<VistaMapaEstanterias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titulo: 'ESTANTES'),

      body: SafeArea(
        child: _MapView(
          estantes: [
            ImagenRelleno(
              """Las aves marinas son un tipo de aves adaptadas para la vida en hábitats marinos. Si bien son muy distintas entre sí en cuanto a su estilo de vida, comportamiento y fisiología, suelen manifestar casos de evolución convergente, dado que desarrollaron adaptaciones similares ante problemas idénticos, relacionados con el ambiente y los nichos de alimentación.[1]​ Las primeras aves marinas evolucionaron en el período Cretácico, aunque las familias modernas surgieron en el Paleógeno.[2]​
Por lo general, las aves marinas viven mucho tiempo, se reproducen más tarde y en sus poblaciones hay menos individuos jóvenes, a los que los adultos dedican mucho tiempo.[3]​ Numerosas especies anidan en colonias, que pueden variar de tamaño entre una docena de aves y millones.[4]​ Otras son conocidas por realizar largas migraciones anuales, que las llevan a cruzar el ecuador o en muchos casos rodear la Tierra.[5]​ Pueden alimentarse en la superficie del océano o en sus profundidades, e incluso entre sí. Algunas son pelágicas o costeras, mientras que otras pasan parte del año alejadas completamente del mar.""",
              porcentaje: 0.4,
              url: 'assets/images/elements/elementShelf.png',
              alto: 100,
              ancho: 100,
            ),
            ImagenRelleno(
              "interpolación 2",
              porcentaje: 0.9,
              url: 'assets/images/elements/elementShelf.png',
              alto: 100,
              ancho: 100,
            ),
            ImagenRelleno(
              "interpolación 3",
              porcentaje: 0.2,
              url: 'assets/images/elements/elementShelf.png',
              alto: 100,
              ancho: 100,
            ),
            ImagenRelleno(
              "interpolación 4",
              porcentaje: 0.3,
              url: 'assets/images/elements/elementShelf.png',
              alto: 100,
              ancho: 100,
            ),
            ImagenRelleno(
              "interpolación 5",
              porcentaje: 0.6,
              url: 'assets/images/elements/elementShelf.png',
              alto: 100,
              ancho: 100,
            ),
          ],
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
                      ? SizedBox()
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
                                        imagenSeleccionada!.info!,
                                        style: const TextStyle(fontSize: 16),
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
