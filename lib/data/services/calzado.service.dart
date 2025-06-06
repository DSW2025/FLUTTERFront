import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pakapp/data/models/calzado.model.dart';
import 'package:pakapp/data/models/detalleCalzado.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalzadoService {
  static Future<CalzadoDetalle> obtenerDatosCalzado(String codigoBarras) async {
    final url = Uri.parse(
      'https://test-drive.org/api/calzados/$codigoBarras/datos',
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return CalzadoDetalle.fromJson(json);
    } else {
      throw Exception('Error al obtener datos del calzado: ${response.body}');
    }
  }

  static Future<List<Calzado>> obtenerCalzados() async {
    final url = Uri.parse('https://test-drive.org/api/calzados');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((item) => Calzado.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener calzados: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> enviarRelacionCalzadoEstante({
    required String codigoBarras,
    required int idEstante,
    required int idTalla,
    required int idColor,
    required int cantidad,
  }) async {
    final url = Uri.parse('https://test-drive.org/api/relCaEs');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'codigoBarras': codigoBarras,
        'idEstante': idEstante,
        'idTalla': idTalla,
        'idColor': idColor,
        'cantidad': cantidad,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Error al enviar relación: ${response.body}');
    }
  }

  static obtenerImagen(codigoBarras) async {
    final url = Uri.parse(
      'https://test-drive.org/api/calzados/$codigoBarras/imagen',
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
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

  static Future<bool> actualizarRelacionEstante({
    required int idCalzadoEstante,
    required String codigoBarras,
    required int idEstante,
    required int idTalla,
    required int idColor,
    required int cantidad,
  }) async {
    final url = Uri.parse(
      'https://test-drive.org/api/relCaEs/$idCalzadoEstante',
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'codigoBarras': codigoBarras,
        'idEstante': idEstante,
        'idTalla': idTalla,
        'idColor': idColor,
        'cantidad': cantidad,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al actualizar relación: ${response.body}');
    }
  }
}
