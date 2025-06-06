import 'package:flutter/material.dart';
import 'package:pakapp/data/models/color.model.dart';
import 'package:pakapp/data/services/color.service.dart';

class VistaColores extends StatefulWidget {
  const VistaColores({Key? key}) : super(key: key);

  @override
  _VistaColoresState createState() => _VistaColoresState();
}

class _VistaColoresState extends State<VistaColores> {
  final ColorService _colorService = ColorService();
  late Future<List<ColorModel>> _futureColores;

  @override
  void initState() {
    super.initState();
    _cargarColores();
  }

  void _cargarColores() {
    setState(() {
      _futureColores = _colorService.obtenerColores();
    });
  }

  Future<void> _mostrarDialogoCrear() async {
    final TextEditingController _nombreController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear nuevo color'),
          content: TextField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre del color',
              hintText: 'p.ej. magenta',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String nombre = _nombreController.text.trim();
                if (nombre.isEmpty) return;

                try {
                  await _colorService.crearColor(nombreColor: nombre);
                  Navigator.of(context).pop();
                  _cargarColores();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Color "$nombre" creado')),
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

  Future<void> _mostrarDialogoEditar(ColorModel color) async {
    final TextEditingController _editarController =
        TextEditingController(text: color.color);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar color'),
          content: TextField(
            controller: _editarController,
            decoration: const InputDecoration(
              labelText: 'Nuevo nombre del color',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String nuevoNombre = _editarController.text.trim();
                if (nuevoNombre.isEmpty) return;

                try {
                  await _colorService.actualizarColor(
                    id: color.idColor,
                    nuevoNombreColor: nuevoNombre,
                  );
                  Navigator.of(context).pop();
                  _cargarColores();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Color "${color.color}" actualizado a "$nuevoNombre"',
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

  Future<void> _eliminarColor(int idColor, String nombreColor) async {
    try {
      await _colorService.eliminarColor(id: idColor);
      _cargarColores();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Color "$nombreColor" eliminado')),
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
        title: const Text('CRUD de Colores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear nuevo color',
            onPressed: _mostrarDialogoCrear,
          ),
        ],
      ),
      body: FutureBuilder<List<ColorModel>>(
        future: _futureColores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar colores:\n${snapshot.error}'),
            );
          }
          final colores = snapshot.data!;
          if (colores.isEmpty) {
            return const Center(child: Text('No hay colores registradas.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: colores.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final color = colores[index];
              return ListTile(
                title: Text(color.color),
                subtitle: Text('ID: ${color.idColor}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () => _mostrarDialogoEditar(color),
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
                                '¿Seguro que deseas eliminar "${color.color}"?',
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
                          _eliminarColor(color.idColor, color.color);
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
