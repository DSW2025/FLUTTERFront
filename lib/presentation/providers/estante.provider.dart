import 'package:flutter/material.dart';
import 'package:pakapp/data/models/estante.model.dart';
import 'package:pakapp/data/services/estante.service.dart';

class EstantesProvider extends ChangeNotifier {
  List<EstanteDatos> _estantes = [];
  bool _cargando = false;
  String? _error;

  List<EstanteDatos> get estantes => _estantes;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarEstantes() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final datos = await EstanteService.obtenerEstantes();
      _estantes = datos.map((e) => EstanteDatos.fromModel(e)).toList();
      await Future.wait(
        _estantes.map((est) async {
          final relaciones = await EstanteService.obtenerPorEstante(
            est.idEstante,
          );
          final sumaCant = relaciones.fold<int>(0, (s, r) => s + r.cantidad);
          est.capacidadOcupada = sumaCant;
          est.capacidadDisponible = est.capacidadMaxima - sumaCant;
        }),
      );
    } catch (e) {
      _error = 'Error al cargar estantes: $e';
      _estantes = [];
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> recargar() async => await cargarEstantes();
}

class EstanteDatos {
  final int idEstante;
  final String localizacion;
  int capacidadMaxima;
  int capacidadOcupada;
  int capacidadDisponible;

  EstanteDatos({
    required this.idEstante,
    required this.localizacion,
    required this.capacidadMaxima,
    this.capacidadOcupada = 0,
    this.capacidadDisponible = 0,
  });

  factory EstanteDatos.fromModel(Estante m) => EstanteDatos(
    idEstante: m.idEstante,
    localizacion: m.localizacion,
    capacidadMaxima: m.capacidadMaxima,
    capacidadOcupada: m.capacidadOcupada, // inicial, pero lo vamos a recalcular
    capacidadDisponible: m.capacidadDisponible, // idem
  );

  double get porcentaje =>
      capacidadMaxima == 0 ? 0.0 : capacidadOcupada / capacidadMaxima;

  String get info =>
      'ID: $idEstante\n'
      'Ubicación: $localizacion\n'
      'Máxima: $capacidadMaxima\n'
      'Ocupado: $capacidadOcupada\n'
      'Disponibles: $capacidadDisponible';
}
