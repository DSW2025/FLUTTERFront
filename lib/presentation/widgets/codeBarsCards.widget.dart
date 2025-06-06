import 'package:flutter/material.dart';
import 'package:pakapp/data/models/detalleCalzado.model.dart';
import 'package:pakapp/data/models/estante.model.dart';
import 'package:pakapp/data/services/calzado.service.dart';
import 'package:pakapp/data/services/estante.service.dart';

class CartaCodigoBarras extends StatefulWidget {
  final CalzadoDetalle calzado;
  final VoidCallback onChanged;

  const CartaCodigoBarras({
    super.key,
    required this.calzado,
    required this.onChanged,
  });

  @override
  State<CartaCodigoBarras> createState() => _CartaCodigoBarrasState();
}

class _CartaCodigoBarrasState extends State<CartaCodigoBarras> {
  late TextEditingController _cantidadController;
  int? _idTallaSeleccionada;
  int? _idColorSeleccionado;
  int? _idEstanteSeleccionado;
  List<Estante> _estantes = [];
  bool _cargandoEstantes = true;

  @override
  void initState() {
    super.initState();
    _cantidadController = TextEditingController(
      text: widget.calzado.cantidad.toString(),
    );
    _cargarEstantes();
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _cargarEstantes() async {
    try {
      // llamada al service corregido
      final estantes = await EstanteService.obtenerEstantes();
      setState(() {
        _estantes = estantes;
        _idEstanteSeleccionado ??=
            estantes.isNotEmpty ? estantes.first.idEstante : null;
        _cargandoEstantes = false;
      });
    } catch (e) {
      setState(() => _cargandoEstantes = false);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar estantes: $e')));
      }
    }
  }

  void _actualizarCantidad(int nuevaCantidad) {
    setState(() {
      widget.calzado.cantidad = nuevaCantidad;
      _cantidadController.text = nuevaCantidad.toString();
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final calzado = widget.calzado;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              calzado.modelo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _idColorSeleccionado,
                    isExpanded: true,
                    items:
                        calzado.colores.map<DropdownMenuItem<int>>((c) {
                          return DropdownMenuItem(
                            value: c['idColor'],
                            child: Text(c['color'] ?? 'Desconocido'),
                          );
                        }).toList(),
                    onChanged:
                        (value) => setState(() => _idColorSeleccionado = value),
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _idTallaSeleccionada,
                    isExpanded: true,
                    items:
                        calzado.tallas.map<DropdownMenuItem<int>>((t) {
                          return DropdownMenuItem(
                            value: t['idTalla'],
                            child: Text(t['talla'].toString()),
                          );
                        }).toList(),
                    onChanged:
                        (value) => setState(() => _idTallaSeleccionada = value),
                    decoration: const InputDecoration(
                      labelText: 'Talla',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _cargandoEstantes
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<int>(
                  value: _idEstanteSeleccionado,
                  isExpanded: true,
                  items:
                      _estantes.map((e) {
                        return DropdownMenuItem(
                          value: e.idEstante,
                          child: Text(e.localizacion),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _idEstanteSeleccionado = value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Estante',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (calzado.cantidad > 0) {
                          _actualizarCantidad(calzado.cantidad - 1);
                        }
                      },
                    ),
                    SizedBox(
                      width: 48,
                      height: 36,
                      child: Center(
                        child: TextFormField(
                          controller: _cantidadController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 6,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            final parsed = int.tryParse(value);
                            if (parsed != null && parsed >= 0) {
                              widget.calzado.cantidad = parsed;
                              widget.onChanged();
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed:
                          () => _actualizarCantidad(calzado.cantidad + 1),
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Guardar relación'),
                  onPressed:
                      (_idEstanteSeleccionado != null &&
                              _idTallaSeleccionada != null &&
                              _idColorSeleccionado != null &&
                              int.tryParse(_cantidadController.text) != null &&
                              int.parse(_cantidadController.text) > 0)
                          ? () async {
                            final cantidad = int.parse(
                              _cantidadController.text,
                            );
                            try {
                              await CalzadoService.enviarRelacionCalzadoEstante(
                                codigoBarras: calzado.codigoBarras,
                                idEstante: _idEstanteSeleccionado!,
                                idTalla: _idTallaSeleccionada!,
                                idColor: _idColorSeleccionado!,
                                cantidad: cantidad,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Relación guardada correctamente',
                                  ),
                                ),
                              );
                              widget.onChanged();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                          : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
