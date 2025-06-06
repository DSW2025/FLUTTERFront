import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pakapp/data/services/auth.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _rol;

  String? get token => _token;
  String? get rol => _rol;

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final data = await AuthService.login(email, password);
      final tokenGuardado = data['token'] as String;

      final payload = JwtDecoder.decode(tokenGuardado);
      final String rolRecibido = payload['rol'] as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('rol', rolRecibido);

      _token = tokenGuardado;
      _rol = rolRecibido;
      notifyListeners();

      if (_rol == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
      );
    }
  }

  // Llamar esto al inicio de la app para recuperar token y rol guardados
  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tokenGuardado = prefs.getString('token');
    final String? rolGuardado = prefs.getString('rol');

    _token = tokenGuardado;
    _rol = rolGuardado;
    notifyListeners();
  }
}
