import 'package:flutter/material.dart';
import 'package:pakapp/data/models/calzadoEstante.model.dart';
import 'package:pakapp/data/services/calzado.service.dart';
import 'package:pakapp/presentation/widgets/appBar.widget.dart';

class VistaDetalleCalzado extends StatefulWidget {
  final CalzadoRelacion calzado;

  const VistaDetalleCalzado({super.key, required this.calzado});

  @override
  State<VistaDetalleCalzado> createState() => _VistaDetalleCalzadoState();
}

class _VistaDetalleCalzadoState extends State<VistaDetalleCalzado> {
  late final TextEditingController cantidadController;
  List<dynamic> _colores = [];
  List<dynamic> _tallas = [];
  String? _colorSeleccionado;
  String? _tallaSeleccionada;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    cantidadController = TextEditingController(
      text: widget.calzado.cantidad.toString(),
    );
    _cargarDetalles();
  }

  void _cargarDetalles() async {
    try {
      final detalle = await CalzadoService.obtenerDatosCalzado(
        widget.calzado.codigoBarras,
      );

      // Ordenar las listas por su id respectivo
      detalle.colores.sort(
        (a, b) => (a['idColor'] as int).compareTo(b['idColor'] as int),
      );
      detalle.tallas.sort(
        (a, b) => (a['idTalla'] as int).compareTo(b['idTalla'] as int),
      );

      final nombresColores =
          detalle.colores.map((c) => c['color']?.toString()).toList();
      final valoresTallas =
          detalle.tallas.map((t) => t['talla']?.toString()).toList();

      setState(() {
        _colores = detalle.colores;
        _tallas = detalle.tallas;

        // Si el color del widget calzado está entre los colores disponibles, se usa; si no, se toma el primero
        _colorSeleccionado =
            nombresColores.contains(widget.calzado.color)
                ? widget.calzado.color
                : (nombresColores.isNotEmpty ? nombresColores.first : null);

        // Lo mismo para la talla
        _tallaSeleccionada =
            valoresTallas.contains(widget.calzado.talla)
                ? widget.calzado.talla.toString()
                : (valoresTallas.isNotEmpty ? valoresTallas.first : null);

        _cargando = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: ${e.toString()}')),
      );
      setState(() => _cargando = false);
    }
  }

  void _guardarCambios() async {
    final cantidadTexto = cantidadController.text.trim();

    if (cantidadTexto.isEmpty || int.tryParse(cantidadTexto) == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cantidad inválida')));
      return;
    }

    final cantidad = int.parse(cantidadTexto);
    if (cantidad < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cantidad no puede ser negativa')),
      );
      return;
    }

    final idColor =
        _colores.firstWhere(
          (c) => c['color'] == _colorSeleccionado,
          orElse: () => {'idColor': widget.calzado.idColor},
        )['idColor'];

    final idTalla =
        _tallas.firstWhere(
          (t) => t['talla'].toString() == _tallaSeleccionada,
          orElse: () => {'idTalla': widget.calzado.idTalla},
        )['idTalla'];

    try {
      final actualizado = await CalzadoService.actualizarRelacionEstante(
        idCalzadoEstante: widget.calzado.idCalzadoEstante,
        codigoBarras: widget.calzado.codigoBarras,
        idEstante: widget.calzado.idEstante!,
        idTalla: idTalla,
        idColor: idColor,
        cantidad: cantidad,
      );

      if (actualizado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios guardados exitosamente')),
        );
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar cambios: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: MyAppBar(titulo: 'CALZADO'),
      body:
          _cargando
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Imagen circular
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              (widget.calzado.nombreImagen != null &&
                                      widget.calzado.nombreImagen!.isNotEmpty)
                                  ? NetworkImage(widget.calzado.nombreImagen!)
                                  : const AssetImage(
                                        'assets/images/elements/placeholder.jpg',
                                      )
                                      as ImageProvider,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      widget.calzado.idEstante?.toString() ?? 'Sin estante',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    Text(
                      widget.calzado.modelo,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'Código: ${widget.calzado.codigoBarras}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 12),

                    // Dropdown para Color
                    DropdownButtonFormField<String>(
                      value: _colorSeleccionado,
                      items:
                          _colores.map<DropdownMenuItem<String>>((c) {
                            final nombre = c['color'] ?? 'Desconocido';
                            return DropdownMenuItem<String>(
                              value: nombre,
                              child: Text(nombre),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() => _colorSeleccionado = value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Color',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Dropdown para Talla
                    DropdownButtonFormField<String>(
                      value: _tallaSeleccionada,
                      items:
                          _tallas.map<DropdownMenuItem<String>>((t) {
                            final valor = t['talla'].toString();
                            return DropdownMenuItem<String>(
                              value: valor,
                              child: Text(valor),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() => _tallaSeleccionada = value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Talla',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        prefixIcon: Icon(Icons.inventory),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _guardarCambios,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            0,
                            162,
                            255,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Guardar cambios',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
