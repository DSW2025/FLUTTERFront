// lib/services/color.service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/color.model.dart';

class ColorService {
  static const String _baseUrl = 'https://test-drive.org/api/colores';
  static Future<String> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }
    return token;
  }

  Future<ColorModel> crearColor({required String nombreColor}) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/');
    final body = jsonEncode({'color': nombreColor});

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
      // Extraemos el objeto real dentro de "data"
      final Map<String, dynamic> data = decoded['data'];
      return ColorModel.fromJson(data);
    } else {
      throw Exception(
        'Error al crear color: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<ColorModel>> obtenerColores() async {
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
      return data.map((jsonItem) => ColorModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception(
        'Error al obtener colores: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<ColorModel> obtenerColor({required int id}) async {
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
      final data = jsonDecode(response.body);
      return ColorModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Color con id=$id no encontrado.');
    } else {
      throw Exception(
        'Error al obtener color: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<ColorModel> actualizarColor({
    required int id,
    required String nuevoNombreColor,
  }) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$id');
    final body = jsonEncode({'color': nuevoNombreColor});

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
      return ColorModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Color con id=$id no encontrado para actualizar.');
    } else {
      throw Exception(
        'Error al actualizar color: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<void> eliminarColor({required int id}) async {
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
      throw Exception('Color con id=$id no encontrado para eliminar.');
    } else {
      throw Exception(
        'Error al eliminar color: ${response.statusCode} ${response.body}',
      );
    }
  }
}
