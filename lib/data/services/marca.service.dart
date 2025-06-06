import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/marca.model.dart';

class MarcaService {
  static const String _baseUrl = 'https://test-drive.org/api/marcas';

  static Future<String> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }
    return token;
  }

  Future<List<MarcaModel>> obtenerMarcas() async {
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
      return data.map((item) => MarcaModel.fromJson(item)).toList();
    } else {
      throw Exception(
        'Error al obtener marcas: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<MarcaModel> obtenerMarca({ required int id }) async {
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
      return MarcaModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Marca con id=$id no encontrada.');
    } else {
      throw Exception(
        'Error al obtener marca: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<MarcaModel> crearMarca({ required String nombreMarca }) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/');
    final body = jsonEncode({'marca': nombreMarca});

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
      return MarcaModel.fromJson(data);
    } else {
      throw Exception(
        'Error al crear marca: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<MarcaModel> actualizarMarca({
    required int id,
    required String nuevoNombreMarca,
  }) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$id');
    final body = jsonEncode({'marca': nuevoNombreMarca});

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
      return MarcaModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Marca con id=$id no encontrada para actualizar.');
    } else {
      throw Exception(
        'Error al actualizar marca: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<void> eliminarMarca({ required int id }) async {
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
      throw Exception('Marca con id=$id no encontrada para eliminar.');
    } else {
      throw Exception(
        'Error al eliminar marca: ${response.statusCode} ${response.body}',
      );
    }
  }
}
