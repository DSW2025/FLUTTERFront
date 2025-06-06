import 'package:flutter/material.dart';
import 'package:pakapp/data/services/estante.service.dart';

class CapacidadProvider with ChangeNotifier {
  double _porcentaje = 0.0;
  int _disponibles = 0;
  bool _cargando = false;
  String? _error;

  double get porcentaje => _porcentaje;
  int get disponibles => _disponibles;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarCapacidad() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final data = await EstanteService.obtenerCapacidades();
      _porcentaje = data['porcentaje'];
      _disponibles = data['disponibles'];
    } catch (e) {
      _error = 'Error al cargar capacidad: $e';
      _porcentaje = 0.0;
      _disponibles = 0;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> recargar() async {
    await cargarCapacidad();
  }
}
