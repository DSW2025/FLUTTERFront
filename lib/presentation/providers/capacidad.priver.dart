import 'package:flutter/material.dart';
import 'package:pakapp/data/services/estante.service.dart';

class CapacidadProvider with ChangeNotifier {
  double _porcentaje = 0.0;
  int _disponibles = 0;

  double get porcentaje => _porcentaje;
  int get disponibles => _disponibles;

  Future<void> cargarCapacidad() async {
    try {
      final data = await EstanteService.obtenerCapacidades();
      _porcentaje = data['porcentaje'];
      _disponibles = data['disponibles'];
      notifyListeners(); // notifica a los listeners
    } catch (e) {
      throw Exception(e);
    }
  }
}
