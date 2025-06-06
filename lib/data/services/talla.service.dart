import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/talla.model.dart';

class TallaService {
  static const String _baseUrl = 'https://test-drive.org/api/tallas';
  
  static Future<String> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }
    return token;
  }

  // ------- OBTENER LISTADO DE TALLAS (GET "/") -------
  Future<List<TallaModel>> obtenerTallas() async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((item) => TallaModel.fromJson(item)).toList();
    } else {
      throw Exception(
        'Error al obtener tallas: ${response.statusCode} ${response.body}',
      );
    }
  }

  // ------- OBTENER UNA TALLA POR ID (GET "/:id") -------
  Future<TallaModel> obtenerTalla({required int id}) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$id');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final Map<String, dynamic> data = decoded['data'];
      return TallaModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Talla con id=$id no encontrada.');
    } else {
      throw Exception(
        'Error al obtener talla: ${response.statusCode} ${response.body}',
      );
    }
  }

  // ------- CREAR UNA NUEVA TALLA (POST "/") -------
  Future<TallaModel> crearTalla({required String talla, String? genero}) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/');
    final body = jsonEncode({'talla': talla, 'genero': genero});

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final Map<String, dynamic> data = decoded['data'];
      return TallaModel.fromJson(data);
    } else {
      throw Exception(
        'Error al crear talla: ${response.statusCode} ${response.body}',
      );
    }
  }

  // ------- ACTUALIZAR UNA TALLA EXISTENTE (PUT "/:id") -------
  Future<TallaModel> actualizarTalla({
    required int id,
    required String nuevaTalla,
    String? nuevoGenero,
  }) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$id');
    final body = jsonEncode({'talla': nuevaTalla, 'genero': nuevoGenero});

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final Map<String, dynamic> data = decoded['data'];
      return TallaModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Talla con id=$id no encontrada para actualizar.');
    } else {
      throw Exception(
        'Error al actualizar talla: ${response.statusCode} ${response.body}',
      );
    }
  }

  // ------- ELIMINAR UNA TALLA (DELETE "/:id") -------
  Future<void> eliminarTalla({required int id}) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$id');

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Talla con id=$id no encontrada para eliminar.');
    } else {
      throw Exception(
        'Error al eliminar talla: ${response.statusCode} ${response.body}',
      );
    }
  }
}
