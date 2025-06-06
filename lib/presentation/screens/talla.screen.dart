// lib/screens/vista_tallas.dart

import 'package:flutter/material.dart';
import 'package:pakapp/data/models/talla.model.dart';
import 'package:pakapp/data/services/talla.service.dart';

class VistaTallas extends StatefulWidget {
  const VistaTallas({Key? key}) : super(key: key);

  @override
  _VistaTallasState createState() => _VistaTallasState();
}

class _VistaTallasState extends State<VistaTallas> {
  final TallaService _tallaService = TallaService();
  late Future<List<TallaModel>> _futureTallas;

  @override
  void initState() {
    super.initState();
    _cargarTallas();
  }

  void _cargarTallas() {
    setState(() {
      _futureTallas = _tallaService.obtenerTallas();
    });
  }

  /// Retorna `true` si [texto] es "", "Hombre" o "Mujer".
  bool _esGeneroValido(String texto) {
    if (texto.isEmpty) return true;
    return texto == 'Caballero' || texto == 'Dama';
  }

  Future<void> _mostrarDialogoCrear() async {
    final TextEditingController _tallaController = TextEditingController();
    final TextEditingController _generoController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear nueva talla'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tallaController,
                decoration: const InputDecoration(
                  labelText: 'Talla',
                  hintText: 'p.ej. 42, S, M',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _generoController,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  hintText: 'Caballero / Dama',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String nuevaTalla = _tallaController.text.trim();
                final String generoTexto = _generoController.text.trim();

                if (nuevaTalla.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El campo Talla es obligatorio.'),
                    ),
                  );
                  return;
                }

                if (!_esGeneroValido(generoTexto)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El género debe ser "Caballero", "Dama" o dejarse vacío.',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await _tallaService.crearTalla(
                    talla: nuevaTalla,
                    genero: generoTexto.isEmpty ? null : generoTexto,
                  );
                  Navigator.of(context).pop();
                  _cargarTallas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Talla "$nuevaTalla" creada')),
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

  Future<void> _mostrarDialogoEditar(TallaModel tallaModel) async {
    final TextEditingController _tallaController = TextEditingController(
      text: tallaModel.talla,
    );
    final TextEditingController _generoController = TextEditingController(
      text: tallaModel.genero ?? '',
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar talla'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tallaController,
                decoration: const InputDecoration(labelText: 'Talla'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _generoController,
                decoration: const InputDecoration(
                  labelText: 'Género',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String nuevaTalla = _tallaController.text.trim();
                final String generoTexto = _generoController.text.trim();

                if (nuevaTalla.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El campo Talla es obligatorio.'),
                    ),
                  );
                  return;
                }

                if (!_esGeneroValido(generoTexto)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El género debe ser "Caballero", "Dama" o dejarse vacío.',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await _tallaService.actualizarTalla(
                    id: tallaModel.idTalla,
                    nuevaTalla: nuevaTalla,
                    nuevoGenero: generoTexto.isEmpty ? null : generoTexto,
                  );
                  Navigator.of(context).pop();
                  _cargarTallas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Talla "${tallaModel.talla}" actualizada a "$nuevaTalla"',
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

  Future<void> _eliminarTalla(int idTalla, String nombreTalla) async {
    try {
      await _tallaService.eliminarTalla(id: idTalla);
      _cargarTallas();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Talla "$nombreTalla" eliminada')));
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
        title: const Text('CRUD de Tallas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear nueva talla',
            onPressed: _mostrarDialogoCrear,
          ),
        ],
      ),
      body: FutureBuilder<List<TallaModel>>(
        future: _futureTallas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar tallas:\n${snapshot.error}'),
            );
          }
          final tallas = snapshot.data!;
          if (tallas.isEmpty) {
            return const Center(child: Text('No hay tallas registradas.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: tallas.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tallaModel = tallas[index];
              return ListTile(
                title: Text(tallaModel.talla),
                subtitle: Text(
                  tallaModel.genero != null && tallaModel.genero!.isNotEmpty
                      ? 'Género: ${tallaModel.genero}'
                      : 'Género: N/A',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () => _mostrarDialogoEditar(tallaModel),
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
                                '¿Seguro que deseas eliminar la talla "${tallaModel.talla}"?',
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
                          _eliminarTalla(tallaModel.idTalla, tallaModel.talla);
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
