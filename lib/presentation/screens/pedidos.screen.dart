import 'package:flutter/material.dart';
import 'package:pakapp/presentation/providers/cart.provider.dart';
import 'package:provider/provider.dart';
import 'package:pakapp/data/models/calzadoAdmin.model.dart';
import 'package:pakapp/data/services/calzadoAdmin.service.dart';

class VistaPedidos extends StatefulWidget {
  const VistaPedidos({Key? key}) : super(key: key);

  @override
  State<VistaPedidos> createState() => _VistaPedidosState();
}

class _VistaPedidosState extends State<VistaPedidos> {
  late Future<List<CalzadoModel>> _futureCalzados;
  final CalzadoService calzadoService = CalzadoService();

  @override
  void initState() {
    super.initState();
    _futureCalzados = calzadoService.obtenerCalzados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Calzados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/carrito');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CalzadoModel>>(
        future: _futureCalzados,
        builder: (context, snapshot) {
          // 1) Estados de conexión
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) Si hubo error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar calzados:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          // 3) Si terminó y no hay datos o lista vacía
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay calzados registrados.'));
          }

          // 4) Lista no vacía: construimos el ListView
          final calzados = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: calzados.length,
            itemBuilder: (context, index) {
              return CalzadoCard(calzado: calzados[index]);
            },
          );
        },
      ),
    );
  }
}

class CalzadoCard extends StatefulWidget {
  final CalzadoModel calzado;

  const CalzadoCard({required this.calzado, Key? key}) : super(key: key);

  @override
  State<CalzadoCard> createState() => _CalzadoCardState();
}

class _CalzadoCardState extends State<CalzadoCard> {
  late Future<dynamic> _futureImageUrl;
  int _cantidad = 1;

  @override
  void initState() {
    super.initState();
    _futureImageUrl = CalzadoService.obtenerImagen(widget.calzado.codigoBarras);
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el proveedor del carrito
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen del producto (placeholder o cargada con FutureBuilder)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
              child: FutureBuilder<dynamic>(
                future: _futureImageUrl,
                builder: (context, imgSnapshot) {
                  // 1) Mientras carga
                  if (imgSnapshot.connectionState == ConnectionState.waiting ||
                      imgSnapshot.connectionState == ConnectionState.active) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // 2) Si hubo error
                  if (imgSnapshot.hasError) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  }
                  final data = imgSnapshot.data;
                  String? imageUrl;
                  if (data != null) {
                    imageUrl = data.toString();
                    if (imageUrl.isEmpty) imageUrl = null;
                  }

                  if (imageUrl != null) {
                    return Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey),
                    );
                  }
                },
              ),
            ),

            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.calzado.modelo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Código de barras: ${widget.calzado.codigoBarras}'),
                  const SizedBox(height: 4),
                  Text('ID Marca: ${widget.calzado.idMarca}'),
                  const SizedBox(height: 4),
                  Text('Costo: \$${widget.calzado.costo.toStringAsFixed(2)}'),
                ],
              ),
            ),

            const SizedBox(width: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selector de cantidad
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (_cantidad > 1) {
                          setState(() {
                            _cantidad--;
                          });
                        }
                      },
                    ),
                    Text('$_cantidad', style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          _cantidad++;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Botón “Añadir al carrito”
                ElevatedButton.icon(
                  onPressed: () {
                    // Invocamos al provider para agregar al carrito
                    cartProvider.addItem(widget.calzado, _cantidad);
                    // Opcional: mostrar mensaje SnackBar
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Se añadió $_cantidad × ${widget.calzado.modelo} al carrito.',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Añadir'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
