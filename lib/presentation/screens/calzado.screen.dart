import 'package:flutter/material.dart';
import 'package:pakapp/data/models/calzadoAdmin.model.dart';
import 'package:pakapp/data/services/calzadoAdmin.service.dart';

class VistaCalzados extends StatefulWidget {
  const VistaCalzados({super.key});

  @override
  State<VistaCalzados> createState() => _VistaCalzadosState();
}

class _VistaCalzadosState extends State<VistaCalzados> {
  final CalzadoService _calzadoService = CalzadoService();
  late Future<List<CalzadoModel>> _futureCalzados;

  @override
  void initState() {
    super.initState();
    _cargarCalzados();
  }

  void _cargarCalzados() {
    setState(() {
      _futureCalzados = _calzadoService.obtenerCalzados();
    });
  }

  int? _parsearEntero(String texto) {
    try {
      return int.parse(texto);
    } catch (_) {
      return null;
    }
  }

  double? _parsearDouble(String texto) {
    try {
      return double.parse(texto);
    } catch (_) {
      return null;
    }
  }

  Future<void> _mostrarDialogoCrear() async {
    final TextEditingController _codigoController = TextEditingController();
    final TextEditingController _idMarcaController = TextEditingController();
    final TextEditingController _modeloController = TextEditingController();
    final TextEditingController _costoController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear nuevo calzado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código de Barras',
                    hintText: 'p.ej. 0070847035916',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _idMarcaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ID Marca',
                    hintText: 'Entero',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _modeloController,
                  decoration: const InputDecoration(
                    labelText: 'Modelo',
                    hintText: 'p.ej. Blaze Max',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _costoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Costo',
                    hintText: 'Entero > 0',
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
                final String codigo = _codigoController.text.trim();
                final String idMarcaText = _idMarcaController.text.trim();
                final String modelo = _modeloController.text.trim();
                final String costoText = _costoController.text.trim();

                if (codigo.isEmpty ||
                    idMarcaText.isEmpty ||
                    modelo.isEmpty ||
                    costoText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todos los campos son obligatorios.'),
                    ),
                  );
                  return;
                }

                final int? idMarca = _parsearEntero(idMarcaText);
                final double? costo = _parsearDouble(costoText);

                if (idMarca == null || idMarca <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ID Marca debe ser un entero > 0.'),
                    ),
                  );
                  return;
                }
                if (costo == null || costo <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Costo debe ser un entero > 0.'),
                    ),
                  );
                  return;
                }

                try {
                  await _calzadoService.crearCalzado(
                    codigoBarras: codigo,
                    idMarca: idMarca,
                    modelo: modelo,
                    costo: costo,
                  );
                  Navigator.of(context).pop();
                  _cargarCalzados();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calzado "$modelo" creado')),
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

  Future<void> _mostrarDialogoEditar(CalzadoModel calzado) async {
    final TextEditingController _idMarcaController = TextEditingController(
      text: calzado.idMarca.toString(),
    );
    final TextEditingController _modeloController = TextEditingController(
      text: calzado.modelo,
    );
    final TextEditingController _costoController = TextEditingController(
      text: calzado.costo.toString(),
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar calzado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // No permitimos editar el código de barras
                Text('Código: ${calzado.codigoBarras}'),
                const SizedBox(height: 12),
                TextField(
                  controller: _idMarcaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'ID Marca'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _costoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Costo'),
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
                final String idMarcaText = _idMarcaController.text.trim();
                final String modelo = _modeloController.text.trim();
                final String costoText = _costoController.text.trim();

                if (idMarcaText.isEmpty ||
                    modelo.isEmpty ||
                    costoText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'ID Marca, Modelo y Costo son obligatorios.',
                      ),
                    ),
                  );
                  return;
                }

                final int? idMarca = _parsearEntero(idMarcaText);
                final double? costo = _parsearDouble(costoText);

                if (idMarca == null || idMarca <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ID Marca debe ser un entero > 0.'),
                    ),
                  );
                  return;
                }
                if (costo == null || costo <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Costo debe ser un entero > 0.'),
                    ),
                  );
                  return;
                }

                try {
                  await _calzadoService.actualizarCalzado(
                    codigoBarras: calzado.codigoBarras,
                    idMarca: idMarca,
                    modelo: modelo,
                    costo: costo,
                  );
                  Navigator.of(context).pop();
                  _cargarCalzados();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Calzado "${calzado.modelo}" actualizado a "$modelo"',
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

  Future<void> _eliminarCalzado(String codigoBarras, String modelo) async {
    try {
      await _calzadoService.eliminarCalzado(codigoBarras: codigoBarras);
      _cargarCalzados();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Calzado "$modelo" eliminado')));
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
        title: const Text('CRUD de Calzados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear nuevo calzado',
            onPressed: _mostrarDialogoCrear,
          ),
        ],
      ),
      body: FutureBuilder<List<CalzadoModel>>(
        future: _futureCalzados,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar calzados:\n${snapshot.error}'),
            );
          }
          final lista = snapshot.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('No hay calzados registrados.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final calzado = lista[index];
              return ListTile(
                title: Text(calzado.modelo),
                subtitle: Text(
                  'Código: ${calzado.codigoBarras} • Marca ID: ${calzado.idMarca} • Costo: ${calzado.costo}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () => _mostrarDialogoEditar(calzado),
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
                                '¿Seguro que deseas eliminar "${calzado.modelo}"?',
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
                          _eliminarCalzado(
                            calzado.codigoBarras,
                            calzado.modelo,
                          );
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
