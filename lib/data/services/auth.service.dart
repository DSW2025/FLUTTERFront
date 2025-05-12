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

    final data = jsonDecode(response.body);
    final token = data['token'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('error en login: ${response.body}');
    }
  }
}
