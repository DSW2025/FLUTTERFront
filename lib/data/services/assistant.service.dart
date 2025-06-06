import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AssistantService {
  static Future<Map<String, dynamic>> enviarPregunta(String question) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final url = Uri.parse('https://test-drive.org/api/assistant/query');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode == 200) { 
      return jsonDecode(response.body);
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }
}