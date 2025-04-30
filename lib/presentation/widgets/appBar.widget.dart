import 'package:flutter/material.dart';
import 'package:pakapp/presentation/widgets/avatar.widget.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  const MyAppBar({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      title: Text(titulo),
      centerTitle: true,
      elevation: 0.5,
      backgroundColor: Colors.white,
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Perfil(),
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
