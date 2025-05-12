import 'package:flutter/material.dart';
import 'package:pakapp/data/models/detalleCalzado.model.dart';
import 'package:pakapp/data/services/calzado.service.dart';

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

  @override
  void initState() {
    super.initState();
    _cantidadController = TextEditingController(
      text: widget.calzado.cantidad.toString(),
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
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
            // Modelo del calzado
            Text(
              calzado.modelo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            // Desplegables: Color y Talla
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _idColorSeleccionado,
                    isExpanded: true,
                    items:
                        calzado.colores.map<DropdownMenuItem<int>>((c) {
                          final idColor = c['idColor'];
                          final color = c['color'] ?? 'Desconocido';
                          return DropdownMenuItem(
                            value: idColor,
                            child: Text(color),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => _idColorSeleccionado = value);
                    },
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
                          final idTalla = t['idTalla'];
                          final talla = t['talla']?.toString() ?? 'Talla';
                          return DropdownMenuItem(
                            value: idTalla,
                            child: Text(talla),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => _idTallaSeleccionada = value);
                    },
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

            // Estante
            DropdownButtonFormField<int>(
              value: _idEstanteSeleccionado,
              isExpanded: true,
              items:
                  calzado.estantes.map<DropdownMenuItem<int>>((e) {
                    final id = e['idEstante'];
                    final localizacion = e['localizacion'] ?? '---';
                    return DropdownMenuItem(
                      value: id,
                      child: Text(localizacion),
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

            // Cantidad
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  onPressed: () {
                    _actualizarCantidad(calzado.cantidad + 1);
                  },
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
                        final cantidad = int.parse(_cantidadController.text);

                        try {
                          await CalzadoService.enviarRelacionCalzadoEstante(
                            codigoBarras: widget.calzado.codigoBarras,
                            idEstante: _idEstanteSeleccionado!,
                            idTalla: _idTallaSeleccionada!,
                            idColor: _idColorSeleccionado!,
                            cantidad: cantidad,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Relación guardada correctamente'),
                            ),
                          );

                          widget.onChanged(); // Notifica cambios externos
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                      : null, // Desactiva si algún campo no está listo
            ),
          ],
        ),
      ),
    );
  }
}
