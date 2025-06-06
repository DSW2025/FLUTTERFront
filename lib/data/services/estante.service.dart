import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pakapp/data/models/calzadoEstante.model.dart';
import 'package:pakapp/data/models/estante.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EstanteService {
  static Future<List<Estante>> obtenerEstantes() async {
    final url = Uri.parse('https://test-drive.org/api/estantes');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("Token no encontrado");
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['success'] != true) {
        throw Exception('La API devolvió success=false');
      }
      final List<dynamic> listaJson = body['data'] as List<dynamic>;
      return listaJson
          .map((e) => Estante.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Error al obtener estantes: ${response.statusCode}");
    }
  }

  static Future<Map<String, dynamic>> obtenerCapacidades() async {
    final url = Uri.parse('https://test-drive.org/api/estantes/capacidades');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("token no encontrado");
    }
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
      final int ocupada = data['ocupada'] as int;
      final int disponible = data['disponible'] as int;
      final int total = ocupada + disponible;
      final double porcentaje = total == 0 ? 0.0 : ocupada / total;
      return {"porcentaje": porcentaje, "disponibles": disponible};
    } else {
      throw Exception("error al obtener capacidades");
    }
  }

  static Future<List<CalzadoRelacion>> obtenerPorEstante(int idEstante) async {
    final url = Uri.parse(
      'https://test-drive.org/api/relCaEs/detalles/estante/$idEstante',
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("token no encontrado");
    }
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == true) {
        // Aquí body['data'] es un Map, no una List
        final Map<String, dynamic> nivel2 =
            body['data'] as Map<String, dynamic>;

        // La lista real está en nivel2['data']
        final List<dynamic> datos = nivel2['data'] as List<dynamic>;

        return datos
            .map((e) => CalzadoRelacion.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Respuesta no exitosa del servidor');
      }
    } else {
      throw Exception('Error al obtener datos: ${response.statusCode}');
    }
  }

  static Future<List<CalzadoRelacion>> obtenerPorCalzado(
    String idCalzado,
  ) async {
    final url = Uri.parse(
      'https://test-drive.org/api/relCaEs/detalles/calzado/$idCalzado',
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("token no encontrado");
    }
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['success'] == true) {
        final List<dynamic> datos = body['data'] as List<dynamic>;
        return datos.map((e) => CalzadoRelacion.fromJson(e)).toList();
      } else {
        throw Exception('Respuesta no exitosa del servidor');
      }
    } else {
      throw Exception('Error al obtener datos: ${response.statusCode}');
    }
  }

  static Future<void> deleteRelacionCalzadoEstante(int idCalzadoEstante) async {
    final url = Uri.parse(
      'https://test-drive.org/api/relCaEs/$idCalzadoEstante',
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("token no encontrado");
    }

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar la relación: ${response.body}');
    }
  }
}
