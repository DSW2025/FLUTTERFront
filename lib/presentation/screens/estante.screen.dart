import 'package:flutter/material.dart';
import 'package:pakapp/data/models/estanteAdmin.model.dart';
import 'package:pakapp/data/services/estanteAdmin.service.dart';

class VistaEstantes extends StatefulWidget {
  const VistaEstantes({super.key});

  @override
  State<VistaEstantes> createState() => _VistaEstantesState();
}

class _VistaEstantesState extends State<VistaEstantes> {
  final EstanteService _estanteService = EstanteService();
  late Future<List<EstanteModel>> _futureEstantes;

  @override
  void initState() {
    super.initState();
    _cargarEstantes();
  }

  void _cargarEstantes() {
    setState(() {
      _futureEstantes = _estanteService.obtenerEstantes();
    });
  }

  // Helper para convertir texto en entero, con fallback en null
  int? _parsearEntero(String texto) {
    try {
      return int.parse(texto);
    } catch (_) {
      return null;
    }
  }

  Future<void> _mostrarDialogoCrear() async {
    final TextEditingController _localizacionController =
        TextEditingController();
    final TextEditingController _capMaxController = TextEditingController();
    final TextEditingController _capOcupadaController = TextEditingController();
    final TextEditingController _capDisponibleController =
        TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear nuevo estante'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _localizacionController,
                  decoration: const InputDecoration(
                    labelText: 'Localización',
                    hintText: 'p.ej. Pasillo A-1',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _capMaxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad Máxima',
                    hintText: 'Entero > 0',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _capOcupadaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad Ocupada (opcional)',
                    hintText: 'Entero ≥ 0',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _capDisponibleController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad Disponible (opcional)',
                    hintText: 'Entero ≥ 0',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String loc = _localizacionController.text.trim();
                final String capMaxText = _capMaxController.text.trim();
                final String capOcupadaText = _capOcupadaController.text.trim();
                final String capDispText = _capDisponibleController.text.trim();

                // Validar solo localizacion y capacidadMaxima
                if (loc.isEmpty || capMaxText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Localización y Capacidad Máxima son obligatorios.',
                      ),
                    ),
                  );
                  return;
                }

                final int? capMax = _parsearEntero(capMaxText);
                if (capMax == null || capMax <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Capacidad Máxima debe ser un entero > 0.'),
                    ),
                  );
                  return;
                }

                // Si cupo u disponible vienen vacíos, se usarán valores por defecto
                final int capOcup = _parsearEntero(capOcupadaText) ?? 0;
                if (_parsearEntero(capOcupadaText) != null && capOcup < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Capacidad Ocupada debe ser un entero ≥ 0.',
                      ),
                    ),
                  );
                  return;
                }

                final int? capDisp =
                    capDispText.isEmpty ? null : _parsearEntero(capDispText);
                if (capDisp != null && capDisp < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Capacidad Disponible debe ser un entero ≥ 0.',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await _estanteService.crearEstante(
                    localizacion: loc,
                    capacidadMaxima: capMax,
                    capacidadOcupada: capOcup, // si no se ingresó, será 0
                    capacidadDisponible: capDisp,
                  );
                  Navigator.of(context).pop();
                  _cargarEstantes();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Estante "$loc" creado')),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error al crear: $e')));
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarDialogoEditar(EstanteModel estante) async {
    final TextEditingController _localizacionController = TextEditingController(
      text: estante.localizacion,
    );
    final TextEditingController _capMaxController = TextEditingController(
      text: estante.capacidadMaxima.toString(),
    );
    final TextEditingController _capOcupadaController = TextEditingController(
      text: estante.capacidadOcupada.toString(),
    );
    final TextEditingController _capDisponibleController =
        TextEditingController(
          text: estante.capacidadDisponible?.toString() ?? '',
        );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar estante'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _localizacionController,
                  decoration: const InputDecoration(labelText: 'Localización'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _capMaxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad Máxima',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _capOcupadaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad Ocupada (opcional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _capDisponibleController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad Disponible (opcional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String loc = _localizacionController.text.trim();
                final String capMaxText = _capMaxController.text.trim();
                final String capOcupadaText = _capOcupadaController.text.trim();
                final String capDispText = _capDisponibleController.text.trim();

                // Validar solo localizacion y capacidadMaxima
                if (loc.isEmpty || capMaxText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Localización y Capacidad Máxima son obligatorios.',
                      ),
                    ),
                  );
                  return;
                }

                final int? capMax = _parsearEntero(capMaxText);
                if (capMax == null || capMax <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Capacidad Máxima debe ser un entero > 0.'),
                    ),
                  );
                  return;
                }

                // Si no se ingresa capacidadOcupada, conservar el valor actual
                final int capOcup =
                    _parsearEntero(capOcupadaText) ?? estante.capacidadOcupada;
                if (_parsearEntero(capOcupadaText) != null && capOcup < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Capacidad Ocupada debe ser un entero ≥ 0.',
                      ),
                    ),
                  );
                  return;
                }

                // Si no se ingresa capacidadDisponible, conservar el valor actual
                final int? capDisp =
                    capDispText.isEmpty
                        ? estante.capacidadDisponible
                        : _parsearEntero(capDispText);
                if (capDisp != null && capDisp < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Capacidad Disponible debe ser un entero ≥ 0.',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await _estanteService.actualizarEstante(
                    id: estante.idEstante,
                    localizacion: loc,
                    capacidadMaxima: capMax,
                    capacidadOcupada: capOcup,
                    capacidadDisponible: capDisp,
                  );
                  Navigator.of(context).pop();
                  _cargarEstantes();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Estante "${estante.localizacion}" actualizado a "$loc"',
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar: $e')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarEstante(int idEstante, String loc) async {
    try {
      await _estanteService.eliminarEstante(id: idEstante);
      _cargarEstantes();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Estante "$loc" eliminado')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD de Estantes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear nuevo estante',
            onPressed: _mostrarDialogoCrear,
          ),
        ],
      ),
      body: FutureBuilder<List<EstanteModel>>(
        future: _futureEstantes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar estantes:\n${snapshot.error}'),
            );
          }
          final estantes = snapshot.data!;
          if (estantes.isEmpty) {
            return const Center(child: Text('No hay estantes registrados.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: estantes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final est = estantes[index];
              return ListTile(
                title: Text(est.localizacion),
                subtitle: Text(
                  'Máx: ${est.capacidadMaxima}, Ocupada: ${est.capacidadOcupada}, Disp: ${est.capacidadDisponible ?? 0}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () => _mostrarDialogoEditar(est),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Confirmar eliminación'),
                              content: Text(
                                '¿Seguro que deseas eliminar el estante "${est.localizacion}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm == true) {
                          _eliminarEstante(est.idEstante, est.localizacion);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
