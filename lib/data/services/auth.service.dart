import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('https://test-drive.org/api/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correoElectronico': email, 'contraseña': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['token'] == null || data['token'].toString().isEmpty) {
        throw Exception('Token ausente en la respuesta del backend');
      }

      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return data;
    } else {
      throw Exception('Error en login: ${response.body}');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No hay sesión activa');
    }

    final url = Uri.parse('https://test-drive.org/api/logout');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await prefs.remove('token'); // Limpia token localmente
    } else {
      throw Exception('Error al cerrar sesión: ${response.statusCode}');
    }
  }
}
