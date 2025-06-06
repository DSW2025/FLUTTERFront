import 'package:flutter/material.dart';
import 'package:pakapp/data/models/colaborador.model.dart';
import 'package:pakapp/data/services/colaborador.service.dart';

class VistaColaboradores extends StatefulWidget {
  const VistaColaboradores({super.key});

  @override
  State<VistaColaboradores> createState() => _VistaColaboradoresState();
}

class _VistaColaboradoresState extends State<VistaColaboradores> {
  final ColaboradorService _colService = ColaboradorService();
  late Future<List<ColaboradorModel>> _futureColaboradores;

  @override
  void initState() {
    super.initState();
    _cargarColaboradores();
  }

  void _cargarColaboradores() {
    setState(() {
      _futureColaboradores = _colService.obtenerColaboradores();
    });
  }

  bool _esEmailValido(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  Future<void> _mostrarDialogoCrear() async {
    final TextEditingController _nombresController = TextEditingController();
    final TextEditingController _apellidosController = TextEditingController();
    final TextEditingController _correoController = TextEditingController();
    String _rolSeleccionado = 'empleado';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear nuevo colaborador'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nombresController,
                  decoration: const InputDecoration(
                    labelText: 'Nombres',
                    hintText: 'p.ej. Juan',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos (opcional)',
                    hintText: 'p.ej. Pérez',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _correoController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    hintText: 'p.ej. usuario@dominio.com',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _rolSeleccionado,
                  items: const [
                    DropdownMenuItem(
                      value: 'empleado',
                      child: Text('empleado'),
                    ),
                    DropdownMenuItem(value: 'admin', child: Text('admin')),
                  ],
                  onChanged: (value) {
                    if (value != null) _rolSeleccionado = value;
                  },
                  decoration: const InputDecoration(labelText: 'Rol'),
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
                final String nombres = _nombresController.text.trim();
                final String apellidos = _apellidosController.text.trim();
                final String correo = _correoController.text.trim();

                if (nombres.isEmpty || correo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Nombres y Correo Electrónico son obligatorios.',
                      ),
                    ),
                  );
                  return;
                }
                if (!_esEmailValido(correo)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Correo Electrónico no es válido.'),
                    ),
                  );
                  return;
                }

                try {
                  await _colService.crearColaborador(
                    nombres: nombres,
                    apellidos: apellidos.isEmpty ? null : apellidos,
                    correoElectronico: correo,
                    rol: _rolSeleccionado,
                  );
                  Navigator.of(context).pop();
                  _cargarColaboradores();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Colaborador "$nombres" creado')),
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

  Future<void> _mostrarDialogoEditar(ColaboradorModel col) async {
    final TextEditingController _nombresController = TextEditingController(
      text: col.nombres,
    );
    final TextEditingController _apellidosController = TextEditingController(
      text: col.apellidos,
    );
    final TextEditingController _correoController = TextEditingController(
      text: col.correoElectronico,
    );
    String _rolSeleccionado = col.rol;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar colaborador'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nombresController,
                  decoration: const InputDecoration(labelText: 'Nombres'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos (opcional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _correoController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _rolSeleccionado,
                  items: const [
                    DropdownMenuItem(
                      value: 'empleado',
                      child: Text('empleado'),
                    ),
                    DropdownMenuItem(value: 'admin', child: Text('admin')),
                  ],
                  onChanged: (value) {
                    if (value != null) _rolSeleccionado = value;
                  },
                  decoration: const InputDecoration(labelText: 'Rol'),
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
                final String nombres = _nombresController.text.trim();
                final String apellidos = _apellidosController.text.trim();
                final String correo = _correoController.text.trim();

                if (nombres.isEmpty || correo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Nombres y Correo Electrónico son obligatorios.',
                      ),
                    ),
                  );
                  return;
                }
                if (!_esEmailValido(correo)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Correo Electrónico no es válido.'),
                    ),
                  );
                  return;
                }

                try {
                  await _colService.actualizarColaborador(
                    id: col.idColaborador,
                    nombres: nombres,
                    apellidos: apellidos.isEmpty ? null : apellidos,
                    correoElectronico: correo,
                    rol: _rolSeleccionado,
                  );
                  Navigator.of(context).pop();
                  _cargarColaboradores();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Colaborador "${col.nombres}" actualizado a "$nombres"',
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

  Future<void> _eliminarColaborador(int id, String nombre) async {
    try {
      await _colService.eliminarColaborador(id: id);
      _cargarColaboradores();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Colaborador "$nombre" eliminado')),
      );
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
        title: const Text('CRUD de Colaboradores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear nuevo colaborador',
            onPressed: _mostrarDialogoCrear,
          ),
        ],
      ),
      body: FutureBuilder<List<ColaboradorModel>>(
        future: _futureColaboradores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar colaboradores:\n${snapshot.error}'),
            );
          }
          final lista = snapshot.data!;
          if (lista.isEmpty) {
            return const Center(
              child: Text('No hay colaboradores registrados.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final col = lista[index];
              return ListTile(
                title: Text(col.nombres),
                subtitle: Text('${col.correoElectronico} • Rol: ${col.rol}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () => _mostrarDialogoEditar(col),
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
                                '¿Seguro que deseas eliminar a "${col.nombres}"?',
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
                          _eliminarColaborador(col.idColaborador, col.nombres);
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
