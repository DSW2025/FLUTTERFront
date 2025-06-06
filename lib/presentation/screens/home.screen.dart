import 'package:flutter/material.dart';
import 'package:pakapp/data/models/calzado.model.dart';
import 'package:pakapp/data/models/detalleCalzado.model.dart';
import 'package:pakapp/data/services/calzado.service.dart';
import 'package:pakapp/presentation/providers/capacidad.priver.dart';
import 'package:pakapp/presentation/widgets/appBar.widget.dart';
import 'package:pakapp/presentation/widgets/cardShoes.widget.dart';
import 'package:pakapp/presentation/widgets/cardInformation.widget.dart';
import 'package:pakapp/presentation/widgets/navigator.widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CapacidadProvider>(context, listen: false).cargarCapacidad();
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 20),
                        capacidad.disponibles == 0 && capacidad.porcentaje == 0
                            ? CircularProgressIndicator()
                            : CartaInformacionMejorada(
                              porcentaje: capacidad.porcentaje,
                              disponibles: capacidad.disponibles,
                            ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CarruselCalzados(),
                        ),
                      ],
                    ),
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

// Contenedor de carrusel mejorado
class CarruselCalzados extends StatelessWidget {
  const CarruselCalzados({super.key});

  @override
  Widget build(BuildContext context) {
    return DobleCarruselCompacto();
  }
}

class DobleCarruselCompacto extends StatelessWidget {
  const DobleCarruselCompacto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Calzado>>(
      future: CalzadoService.obtenerCalzados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final todos = snapshot.data!;
        final primeros = todos.take(20).toList();
        final ultimos = todos.skip(todos.length - 20).toList();

        // Tamaño total del carrusel
        const totalHeight = 450.0;
        const trackHeight = totalHeight * 0.5;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              // Pista superior: scroll normal
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: trackHeight,
                child: _CarouselTrack(
                  calzados: primeros,
                  reverse: false,
                  verticalPadding: 4,
                ),
              ),
              // Pista inferior: scroll invertido
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: trackHeight,
                child: _CarouselTrack(
                  calzados: ultimos,
                  reverse: true,
                  verticalPadding: 4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Pista de carrusel horizontal compacta.
class _CarouselTrack extends StatelessWidget {
  final List<Calzado> calzados;
  final bool reverse;
  final double verticalPadding;

  const _CarouselTrack({
    required this.calzados,
    required this.reverse,
    this.verticalPadding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        reverse: reverse,
        physics: const BouncingScrollPhysics(),
        itemCount: calzados.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final calzado = calzados[index];
          return FutureBuilder<CalzadoDetalle>(
            future: CalzadoService.obtenerDatosCalzado(calzado.codigoBarras),
            builder: (ctx, detSnap) {
              if (detSnap.connectionState == ConnectionState.waiting) {
                // Placeholder reducido
                return Container(
                  width: 140,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              } else if (detSnap.hasError) {
                return SizedBox(
                  width: 140,
                  child: Center(
                    child: Icon(Icons.error, color: Colors.red.shade400),
                  ),
                );
              }
              final detalle = detSnap.data!;
              final imagenUrl =
                  'https://test-drive.org/uploads/${detalle.nombreArchivo}';
              // CartaMejorada adaptada a tamaño compacto
              return SizedBox(
                width: 140,
                child: CartaMejorada(
                  imagenUrl: imagenUrl,
                  nombre: detalle.modelo,
                  detalles: detalle,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
