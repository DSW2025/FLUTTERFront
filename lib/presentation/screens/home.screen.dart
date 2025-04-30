import 'package:flutter/material.dart';
import 'package:pakapp/presentation/widgets/appBar.widget.dart';
import 'package:pakapp/presentation/widgets/cardShoes.widget.dart';
import 'package:pakapp/presentation/widgets/cardInformation.widget.dart';
import 'package:pakapp/presentation/widgets/navigator.widget.dart';
import 'package:pakapp/presentation/widgets/sercher.widget.dart';

class VistaHome extends StatefulWidget {
  const VistaHome({super.key});
  @override
  State<VistaHome> createState() => _VistaHomeState();
}

class _VistaHomeState extends State<VistaHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(titulo: 'INICIO'),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/wallpapers/wallpaperHome3.jpg', fit: BoxFit.cover),
          ),
          Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Buscador(),
                  ),
                  
                  CartaInformacion(porcentaje: 0.7, disponibles: 1000),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Últimos agregados",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Carta(
                                'assets/images/logos/logoShoe.png',
                                nombre: 'Zapato para caballero',
                                estante: '(E20)',
                                fecha: 99,
                                cantidad: 99,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              BarraNavegadora(),
            ],
          ),
        ],
      ),
    );
  }
}
