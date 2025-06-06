import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pakapp/data/models/estanteAdmin.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EstanteService {
  static const String _baseUrl = 'https://test-drive.org/api/estantes';

  static Future<String> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }
    return token;
  }

  Future<List<EstanteModel>> obtenerEstantes() async {
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
      return data.map((item) => EstanteModel.fromJson(item)).toList();
    } else {
      throw Exception(
        'Error al obtener estantes: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<EstanteModel> obtenerEstante({ required int id }) async {
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
      return EstanteModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Estante con id=$id no encontrado.');
    } else {
      throw Exception(
        'Error al obtener estante: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<EstanteModel> crearEstante({
    required String localizacion,
    required int capacidadMaxima,
    required int capacidadOcupada,
    int? capacidadDisponible,
  }) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/');
    final body = jsonEncode({
      'localizacion': localizacion,
      'capacidadMaxima': capacidadMaxima,
      'capacidadOcupada': capacidadOcupada,
      'capacidadDisponible': capacidadDisponible,
    });

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
      return EstanteModel.fromJson(data);
    } else {
      throw Exception(
        'Error al crear estante: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<EstanteModel> actualizarEstante({
    required int id,
    required String localizacion,
    required int capacidadMaxima,
    required int capacidadOcupada,
    int? capacidadDisponible,
  }) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$id');
    final body = jsonEncode({
      'localizacion': localizacion,
      'capacidadMaxima': capacidadMaxima,
      'capacidadOcupada': capacidadOcupada,
      'capacidadDisponible': capacidadDisponible,
    });

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
      return EstanteModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Estante con id=$id no encontrado para actualizar.');
    } else {
      throw Exception(
        'Error al actualizar estante: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<void> eliminarEstante({ required int id }) async {
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
      throw Exception('Estante con id=$id no encontrado para eliminar.');
    } else {
      throw Exception(
        'Error al eliminar estante: ${response.statusCode} ${response.body}',
      );
    }
  }
}
