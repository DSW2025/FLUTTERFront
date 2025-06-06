import 'package:flutter/material.dart';
import 'package:pakapp/data/services/auth.service.dart';
import 'package:pakapp/presentation/screens/login.screen.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await AuthService.logout();

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VistaLogin()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'logout') {
          _handleLogout(context);
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
      child: const CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage('assets/images/logos/logoProfile.png'),
      ),
    );
  }
}
