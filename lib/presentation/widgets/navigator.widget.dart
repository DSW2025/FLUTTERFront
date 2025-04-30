import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakapp/presentation/providers/navigator.provider.dart';
import 'package:pakapp/presentation/screens/chat.screen.dart';
import 'package:pakapp/presentation/screens/codeBard.screen.dart';
import 'package:pakapp/presentation/screens/home.screen.dart';
import 'package:pakapp/presentation/screens/map.screen.dart';
import 'package:pakapp/presentation/widgets/iconButton.widget.dart';
import 'package:provider/provider.dart';

class BarraNavegadora extends StatelessWidget {
  final List<IconData> icons = [
    Icons.home,
    Icons.map_outlined,
    Icons.child_care_outlined,
    const IconData(
      0xf586,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage,
    ),
  ];

  final List<Widget> screens = [
    VistaHome(),
    VistaMapaEstanterias(),
    VistaChatBot(),
    VistaCodigoBarras(),
  ];

  BarraNavegadora({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 89, 255),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            return BotonIcono(
              icono: icons[index],
              seleccionado: navProvider.selectedIndex == index,
              onPressed: () {
                navProvider.setIndex(index);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => screens[index]),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
