import 'package:flutter/material.dart';
import 'package:pakapp/data/models/calzado.model.dart';
import 'package:pakapp/data/models/detalleCalzado.model.dart';
import 'package:pakapp/data/services/calzado.service.dart';
import 'package:pakapp/presentation/providers/capacidad.priver.dart';
import 'package:pakapp/presentation/widgets/appBar.widget.dart';
import 'package:pakapp/presentation/widgets/cardShoes.widget.dart';
import 'package:pakapp/presentation/widgets/cardInformation.widget.dart';
import 'package:pakapp/presentation/widgets/navigator.widget.dart';
import 'package:pakapp/presentation/widgets/sercher.widget.dart';
import 'package:provider/provider.dart';

class VistaHome extends StatefulWidget {
  const VistaHome({super.key});
  @override
  State<VistaHome> createState() => _VistaHomeState();
}

class _VistaHomeState extends State<VistaHome> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      await Provider.of<CapacidadProvider>(
        context,
        listen: false,
      ).cargarCapacidad();
    });
  }

  @override
  Widget build(BuildContext context) {
    final capacidad = context.watch<CapacidadProvider>();

    return Scaffold(
      appBar: MyAppBar(titulo: 'INICIO'),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wallpapers/wallpaperHome3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Buscador(),
                      ),

                      capacidad.disponibles == 0 && capacidad.porcentaje == 0
                          ? CircularProgressIndicator()
                          : CartaInformacion(
                            porcentaje: capacidad.porcentaje,
                            disponibles: capacidad.disponibles,
                          ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Calzados Destacados",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(
                              height: 250,
                              child: FutureBuilder<List<Calzado>>(
                                future: CalzadoService.obtenerCalzados(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else {
                                    final calzados = snapshot.data!;
                                    final primeros10 = calzados.take(10);
                                    final ultimos10 = calzados.skip(
                                      calzados.length - 10,
                                    );
                                    final seleccionados = [
                                      ...primeros10,
                                      ...ultimos10,
                                    ];
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: seleccionados.length,
                                      itemBuilder: (context, index) {
                                        final calzado = seleccionados[index];

                                        return FutureBuilder<CalzadoDetalle>(
                                          future:
                                              CalzadoService.obtenerDatosCalzado(
                                                calzado.codigoBarras,
                                              ),
                                          builder: (context, detalleSnapshot) {
                                            if (detalleSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox(
                                                width: 160,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            } else if (detalleSnapshot
                                                .hasError) {
                                              return SizedBox(
                                                width: 160,
                                                child: Text(
                                                  'Error: ${detalleSnapshot.error}',
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              final detalle =
                                                  detalleSnapshot.data!;

                                              final imagenUrl =
                                                  'https://test-drive.org/uploads/${detalle.nombreArchivo}';

                                              return Carta(
                                                imagenUrl,
                                                nombre: detalle.modelo,
                                                estantes: detalle.estantes,
                                              );
                                            }
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BarraNavegadora(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
