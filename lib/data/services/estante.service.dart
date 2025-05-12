import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pakapp/data/models/calzadoEstante.model.dart';
import 'package:pakapp/data/models/estante.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EstanteService {
  static Future<List<Estante>> obtenerEstantes() async {
    final url = Uri.parse('https://test-drive.org/api/estantes');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // recuperacion del token
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
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Estante.fromJson(json)).toList();
    } else {
      throw Exception("error al obtener estantes");
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
      final data = jsonDecode(response.body);
      final ocupada = data["data"]["ocupada"];
      final disponible = data["data"]["disponible"];
      final total = ocupada + disponible;
      final porcentaje = total == 0 ? 0.0 : ocupada / total;
      return {"porcentaje": porcentaje, "disponibles": disponible};
    } else {
      throw Exception("error al obtener capacidades");
    }
  }

  static Future<List<CalzadoEstante>> obtenerCalzadosPorEstante(
    int idEstante,
  ) async {
    final url = Uri.parse(
      'https://test-drive.org/api/estantes/$idEstante/calzados',
    );

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
      final body = jsonDecode(response.body);
      final List<dynamic> calzadosJson = body['data']['calzados'];

      // parsear todos los elementos
      final calzados =
          calzadosJson.map((json) => CalzadoEstante.fromJson(json)).toList();

      // agrupar y sumar por codigoBarras
      final Map<String, int> acumulador = {};

      for (final c in calzados) {
        if (acumulador.containsKey(c.codigoBarras)) {
          acumulador[c.codigoBarras] = acumulador[c.codigoBarras]! + c.cantidad;
        } else {
          acumulador[c.codigoBarras] = c.cantidad;
        }
      }

      // lista unica
      final resultado =
          acumulador.entries.map((e) {
            return CalzadoEstante(codigoBarras: e.key, cantidad: e.value);
          }).toList();

      return resultado;
    } else {
      throw Exception('Error al obtener calzados del estante');
    }
  }
}
