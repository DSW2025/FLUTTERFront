import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pakapp/data/models/calzadoAdmin.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalzadoService {
  static const String _baseUrl = 'https://test-drive.org/api/calzados';

  static Future<String> _obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }
    return token;
  }

  Future<List<CalzadoModel>> obtenerCalzados() async {
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
      return data.map((item) => CalzadoModel.fromJson(item)).toList();
    } else {
      throw Exception(
        'Error al obtener calzados: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<CalzadoModel> obtenerCalzado({required String codigoBarras}) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$codigoBarras');

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
      return CalzadoModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Calzado con código "$codigoBarras" no encontrado.');
    } else {
      throw Exception(
        'Error al obtener calzado: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<CalzadoModel> crearCalzado({
    required String codigoBarras,
    required int idMarca,
    required String modelo,
    required double costo,
  }) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/');
    final body = jsonEncode({
      'codigoBarras': codigoBarras,
      'idMarca': idMarca,
      'modelo': modelo,
      'costo': costo,
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
      return CalzadoModel.fromJson(data);
    } else {
      throw Exception(
        'Error al crear calzado: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<CalzadoModel> actualizarCalzado({
    required String codigoBarras,
    required int idMarca,
    required String modelo,
    required double costo,
  }) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$codigoBarras');
    final body = jsonEncode({
      'idMarca': idMarca,
      'modelo': modelo,
      'costo': costo,
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
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded.containsKey('data')) {
        return CalzadoModel.fromJson(decoded['data'] as Map<String, dynamic>);
      }
      return CalzadoModel(
        codigoBarras: codigoBarras,
        idMarca: idMarca,
        modelo: modelo,
        costo: costo,
      );
    } else if (response.statusCode == 404) {
      throw Exception(
        'Calzado con código "$codigoBarras" no encontrado para actualizar.',
      );
    } else {
      throw Exception(
        'Error al actualizar calzado: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<void> eliminarCalzado({required String codigoBarras}) async {
    final token = await _obtenerToken();
    final uri = Uri.parse('$_baseUrl/$codigoBarras');

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
      throw Exception(
        'Calzado con código "$codigoBarras" no encontrado para eliminar.',
      );
    } else {
      throw Exception(
        'Error al eliminar calzado: ${response.statusCode} ${response.body}',
      );
    }
  }

  static obtenerImagen(codigoBarras) async {
    final url = Uri.parse(
      'https://test-drive.org/api/calzados/$codigoBarras/imagen',
    );

    final token = await _obtenerToken();
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final nombreArchivo = data['data']?['imagen']?['nombreArchivo'];
      if (nombreArchivo != null) {
        return 'https://test-drive.org/uploads/$nombreArchivo';
      } else {
        return null;
      }
    } else {
      throw Exception('Error al obtener la imagen : ${response.body}');
    }
  }
}
