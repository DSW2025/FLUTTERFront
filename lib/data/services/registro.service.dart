import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistroService {
  static Future<Map<String, dynamic>> registrarUsuario({
    required String nombres,
    required String apellidos,
    required String correo,
    required String password,
  }) async {
    final url = Uri.parse('https://test-drive.org/api/colaboradores');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "nombres": nombres,
        "apellidos": apellidos,
        "correoElectronico": correo,
        "contraseña": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        "success": true,
        "message": data["message"] ?? "registro exitoso",
      };
    } else {
      return {
        "success": false,
        "message": data["message"] ?? "error desconocido",
      };
    }
  }
}
