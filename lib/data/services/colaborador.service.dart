import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/colaborador.model.dart';

class ColaboradorService {
  static const String _baseUrl = 'https://test-drive.org/api/colaboradores';

  Future<List<ColaboradorModel>> obtenerColaboradores() async {
    final uri = Uri.parse('$_baseUrl/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((item) => ColaboradorModel.fromJson(item)).toList();
    } else {
      throw Exception(
        'Error al obtener colaboradores: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<ColaboradorModel> obtenerColaborador({required int id}) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final Map<String, dynamic> data = decoded['data'];
      return ColaboradorModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Colaborador con id=$id no encontrado.');
    } else {
      throw Exception(
        'Error al obtener colaborador: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<ColaboradorModel> crearColaborador({
    required String nombres,
    String? apellidos,
    required String correoElectronico,
    required String rol,
  }) async {
    final uri = Uri.parse('$_baseUrl/');
    final body = jsonEncode({
      'nombres': nombres,
      'apellidos': apellidos,
      'correoElectronico': correoElectronico,
      'rol': rol,
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final Map<String, dynamic> data = decoded['data'];
      return ColaboradorModel.fromJson(data);
    } else {
      throw Exception(
        'Error al crear colaborador: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<ColaboradorModel> actualizarColaborador({
    required int id,
    required String nombres,
    String? apellidos,
    required String correoElectronico,
    required String rol,
  }) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final body = jsonEncode({
      'nombres': nombres,
      'apellidos': apellidos,
      'correoElectronico': correoElectronico,
      'rol': rol,
    });

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final Map<String, dynamic> data = decoded['data'];
      return ColaboradorModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Colaborador con id=$id no encontrado para actualizar.');
    } else {
      throw Exception(
        'Error al actualizar colaborador: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<void> eliminarColaborador({required int id}) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(uri);

    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Colaborador con id=$id no encontrado para eliminar.');
    } else {
      throw Exception(
        'Error al eliminar colaborador: ${response.statusCode} ${response.body}',
      );
    }
  }
}
