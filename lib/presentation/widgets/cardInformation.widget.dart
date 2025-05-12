import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pakapp/presentation/providers/navigator.provider.dart';
import 'package:pakapp/presentation/screens/map.screen.dart';
import 'package:pakapp/presentation/widgets/progressContainer.widget.dart';
import 'package:provider/provider.dart';

class CartaInformacion extends StatefulWidget {
  final double porcentaje;
  final int disponibles;
  const CartaInformacion({
    super.key,
    required this.porcentaje,
    required this.disponibles,
  });
  @override
  State<CartaInformacion> createState() => _CartaInformacionState();
}

class _CartaInformacionState extends State<CartaInformacion> {
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),

        child: Container(
          height: screenHeight * 0.24,
          width: screenWidth * 0.94,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.2,
            ), // 👈 Color semitransparente
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.7,
              ), // 
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(30),
          ),

          child: Stack(
            children: [
              SizedBox(
                width: screenWidth * 0.6,
                height: screenHeight * 0.94,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      "Verifica el espacio disponible",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                
                    Text(
                      "${widget.disponibles} LIBRES",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: const Color.fromARGB(255, 0, 200, 255),
                      ),
                    ),
                
                    ElevatedButton(
                      onPressed: () {
                        navProvider.setIndex(1);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VistaMapaEstanterias(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          0,
                          89,
                          255,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        "Explorar...",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.028,
                left: screenWidth * 0.47,
                child: Transform.rotate(
                  angle: -0.7,
                  child: ImagenRelleno(
                    null,
                    porcentaje: widget.porcentaje,
                    url: 'assets/images/elements/elementProgressShoe.PNG',
                    alto: screenHeight * 0.18,
                    ancho: screenWidth * 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
