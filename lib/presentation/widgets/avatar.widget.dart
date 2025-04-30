import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ],
      onSelected: (value) {
        if (value == 'logout') {
          // Aquí haces el logout
        }
      },
      child: CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage('assets/images/logos/logoProfile.png'),
      ),
    );
  }
}
