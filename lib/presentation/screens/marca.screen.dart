import 'package:flutter/material.dart';
import 'package:pakapp/data/models/marca.model.dart';
import 'package:pakapp/data/services/marca.service.dart';

class VistaMarcas extends StatefulWidget {
  const VistaMarcas({super.key});

  @override
  State<VistaMarcas> createState() => _VistaMarcasState();
}

class _VistaMarcasState extends State<VistaMarcas> {
  final MarcaService _marcaService = MarcaService();
  late Future<List<MarcaModel>> _futureMarcas;

  @override
  void initState() {
    super.initState();
    _cargarMarcas();
  }

  void _cargarMarcas() {
    setState(() {
      _futureMarcas = _marcaService.obtenerMarcas();
    });
  }

  Future<void> _mostrarDialogoCrear() async {
    final TextEditingController _marcaController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear nueva marca'),
          content: TextField(
            controller: _marcaController,
            decoration: const InputDecoration(
              labelText: 'Marca',
              hintText: 'p.ej. Nike',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String nombre = _marcaController.text.trim();
                if (nombre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El campo Marca es obligatorio.')),
                  );
                  return;
                }

                try {
                  await _marcaService.crearMarca(nombreMarca: nombre);
                  Navigator.of(context).pop();
                  _cargarMarcas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Marca "$nombre" creada')),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al crear: $e')),
                  );
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarDialogoEditar(MarcaModel marcaModel) async {
    final TextEditingController _marcaController =
        TextEditingController(text: marcaModel.marca);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar marca'),
          content: TextField(
            controller: _marcaController,
            decoration: const InputDecoration(
              labelText: 'Marca',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String nuevoNombre = _marcaController.text.trim();
                if (nuevoNombre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El campo Marca es obligatorio.')),
                  );
                  return;
                }

                try {
                  await _marcaService.actualizarMarca(
                    id: marcaModel.idMarca,
                    nuevoNombreMarca: nuevoNombre,
                  );
                  Navigator.of(context).pop();
                  _cargarMarcas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Marca "${marcaModel.marca}" actualizada a "$nuevoNombre"',
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

  Future<void> _eliminarMarca(int idMarca, String nombreMarca) async {
    try {
      await _marcaService.eliminarMarca(id: idMarca);
      _cargarMarcas();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Marca "$nombreMarca" eliminada')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD de Marcas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear nueva marca',
            onPressed: _mostrarDialogoCrear,
          ),
        ],
      ),
      body: FutureBuilder<List<MarcaModel>>(
        future: _futureMarcas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar marcas:\n${snapshot.error}'),
            );
          }
          final marcas = snapshot.data!;
          if (marcas.isEmpty) {
            return const Center(child: Text('No hay marcas registradas.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: marcas.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final marca = marcas[index];
              return ListTile(
                title: Text(marca.marca),
                subtitle: Text('ID: ${marca.idMarca}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () => _mostrarDialogoEditar(marca),
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
                                '¿Seguro que deseas eliminar la marca "${marca.marca}"?',
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
                          _eliminarMarca(marca.idMarca, marca.marca);
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
