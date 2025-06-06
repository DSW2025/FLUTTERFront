import 'package:flutter/material.dart';
import 'package:pakapp/data/models/calzadoEstante.model.dart';
import 'package:pakapp/data/services/calzado.service.dart';
import 'package:pakapp/data/services/estante.service.dart';
import 'package:pakapp/presentation/providers/estante.provider.dart';
import 'package:pakapp/presentation/providers/calzadoPorEstante.provider.dart';
import 'package:pakapp/presentation/screens/vistaCalzado.screen.dart';
import 'package:provider/provider.dart';

class CardMapWidget extends StatelessWidget {
  final CalzadoRelacion calzado;

  const CardMapWidget({super.key, required this.calzado});

  @override
  Widget build(BuildContext context) {
    final colorVisual = obtenerColorDesdeNombre(calzado.color);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  calzado.modelo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    'ID: ${calzado.idCalzadoEstante}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        "[${calzado.codigoBarras}]",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Marca: ${calzado.marca}",
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text("Color: ", style: TextStyle(fontSize: 13)),
                          Tooltip(
                            message: calzado.color,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: colorVisual,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black26),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Talla: ${calzado.talla}",
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Cantidad: x${calzado.cantidad}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RawMaterialButton(
                      onPressed: () async {
                        final String? imagenUrl =
                            await CalzadoService.obtenerImagen(
                              calzado.codigoBarras,
                            );
                        final calzadoConImagen = CalzadoRelacion(
                          idCalzadoEstante: calzado.idCalzadoEstante,
                          idEstante: calzado.idEstante,
                          cantidad: calzado.cantidad,
                          codigoBarras: calzado.codigoBarras,
                          modelo: calzado.modelo,
                          marca: calzado.marca,
                          color: calzado.color,
                          talla: calzado.talla,
                          idColor: calzado.idColor,
                          idTalla: calzado.idTalla,
                          nombreImagen: imagenUrl,
                        );
                        final bool? actualizado = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => VistaDetalleCalzado(
                                  calzado: calzadoConImagen,
                                ),
                          ),
                        );

                        // ✅ Si se guardaron cambios, actualiza datos
                        if (actualizado == true && context.mounted) {
                          context.read<EstantesProvider>().recargar();
                          context
                              .read<CalzadosPorEstanteProvider>()
                              .cargarPorEstante(calzado.idEstante!);
                        }
                      },
                      elevation: 2,
                      fillColor: Colors.orange,
                      shape: const CircleBorder(),
                      constraints: const BoxConstraints.tightFor(
                        width: 36,
                        height: 36,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    RawMaterialButton(
                      onPressed: () async {
                        final confirmar = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text("Borrar calzado?"),
                                content: const Text(
                                  "Esta acción no se puede deshacer.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: const Text(
                                      "Borrar",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                        if (confirmar == true) {
                          try {
                            await EstanteService.deleteRelacionCalzadoEstante(
                              calzado.idCalzadoEstante,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Calzado borrado"),
                                ),
                              );
                              context.read<EstantesProvider>().recargar();
                              context
                                  .read<CalzadosPorEstanteProvider>()
                                  .cargarPorEstante(calzado.idEstante!);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error al borrar: $e"),
                                ),
                              );
                            }
                          }
                        }
                      },
                      elevation: 2,
                      fillColor: Colors.red,
                      shape: const CircleBorder(),
                      constraints: const BoxConstraints.tightFor(
                        width: 36,
                        height: 36,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color obtenerColorDesdeNombre(String nombre) {
  switch (nombre.toLowerCase()) {
    case 'amarillo':
      return Colors.yellow;
    case 'azul':
      return Colors.blue;
    case 'beige':
      return Colors.redAccent;
    case 'blanco':
      return Colors.white;
    case 'cafe':
      return Colors.brown;
    case 'gris':
      return Colors.grey;
    case 'morado':
      return Colors.purple;
    case 'multicolor':
      return Colors.tealAccent;
    case 'naranja':
      return Colors.orange;
    case 'negro':
      return Colors.black;
    case 'plata':
      return Colors.blueGrey;
    case 'rojo':
      return Colors.red;
    case 'rosa':
      return Colors.pink;
    case 'verde':
      return Colors.green;
    case 'crema':
      return Colors.deepOrangeAccent;
    case 'oro':
      return Colors.amber;
    default:
      return Colors.grey.shade300;
  }
}
