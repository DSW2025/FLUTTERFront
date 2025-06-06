import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  /// Llama al endpoint `/api/create_payment_intent` usando el token en SharedPreferences
  /// y devuelve el clientSecret que crea el PaymentIntent en el backend.
  static Future<String> crearPaymentIntent(int amountInCents) async {
    // 1) Obtener el token de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado en SharedPreferences');
    }

    // 2) Construir la petición
    final uri = Uri.parse('https://test-drive.org/api/create_payment_intent');
    final body = jsonEncode({'amount': amountInCents});

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // 3) Validar código HTTP
    if (response.statusCode != 200) {
      // Puedes agregar más lógica para leer response.body si contiene { error: ... }
      throw Exception(
        'Error creando PaymentIntent: ${response.statusCode} - ${response.body}',
      );
    }

    // 4) Extraer el clientSecret del JSON
    final jsonBody = json.decode(response.body);
    if (jsonBody['clientSecret'] == null) {
      throw Exception('El backend no devolvió clientSecret');
    }

    return jsonBody['clientSecret'] as String;
  }
}
