import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pakapp/presentation/providers/navigator.provider.dart';
import 'package:pakapp/presentation/screens/map.screen.dart';
import 'package:pakapp/presentation/widgets/progressContainer.widget.dart';
import 'package:provider/provider.dart';

class CartaInformacionMejorada extends StatelessWidget {
  final double porcentaje;
  final int disponibles;

  const CartaInformacionMejorada({
    Key? key,
    required this.porcentaje,
    required this.disponibles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final size = MediaQuery.of(context).size;
    // Tono azul corporativo
    const accentBlue = Color.fromARGB(255, 0, 89, 255);

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Glass card
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: size.width * 0.9,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 179, 179, 179),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Progress left
                    SizedBox(
                      width: size.height * 0.18,
                      height: size.height * 0.18,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImagenRelleno(
                            alto: 200,
                            ancho: 200,
                            porcentaje: porcentaje,
                            url:
                                'assets/images/elements/elementProgressShoe.PNG',
                          ),
                          Text(
                            '${(porcentaje * 100).toInt()}%',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              color: accentBlue,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Text and button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Espacio Disponible',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(color: Colors.black45, blurRadius: 6),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$disponibles espacios libres',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: accentBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              navProvider.setIndex(1);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VistaMapaEstanterias(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.map, size: 20),
                            label: const Text('Ver Mapa'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating accent circle
        ],
      ),
    );
  }
}
