import 'package:flutter/material.dart';
import 'package:pakapp/data/models/calzadoEstante.model.dart';
import 'package:pakapp/data/services/estante.service.dart';

class CalzadosPorEstanteProvider extends ChangeNotifier {
  List<CalzadoRelacion> _calzados = [];
  bool _cargando = false;
  String? _error;

  List<CalzadoRelacion> get calzados => _calzados;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarPorEstante(int idEstante) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _calzados = await EstanteService.obtenerPorEstante(idEstante);
    } catch (e) {
      _error = 'Error al cargar calzados: $e';
      _calzados = [];
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void limpiar() {
    _calzados = [];
    _error = null;
    notifyListeners();
  }
}
