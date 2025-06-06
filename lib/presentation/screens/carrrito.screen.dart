import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:pakapp/data/models/itemCart.model.dart';
import 'package:provider/provider.dart';
import 'package:pakapp/presentation/providers/cart.provider.dart';
import 'package:pakapp/data/services/calzadoAdmin.service.dart';
import 'package:pakapp/data/services/payment.service.dart';

class VistaCarrito extends StatefulWidget {
  const VistaCarrito({Key? key}) : super(key: key);

  @override
  State<VistaCarrito> createState() => _VistaCarritoState();
}

class _VistaCarritoState extends State<VistaCarrito> {
  bool _cargandoPago = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final itemsEnCarrito = cartProvider.items;
    final totalMXN = cartProvider.total; // En pesos
    final amountInCents = (totalMXN * 100).toInt(); // Stripe usa centavos

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                itemsEnCarrito.isEmpty
                    ? _buildCarritoVacio()
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      itemCount: itemsEnCarrito.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = itemsEnCarrito[index];
                        return _buildCartItemCard(context, item);
                      },
                    ),
          ),
          if (itemsEnCarrito.isNotEmpty)
            _buildTotalSection(context, totalMXN, amountInCents),
        ],
      ),
    );
  }

  Widget _buildCarritoVacio() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'El carrito está vacío',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Future para la imagen de cada producto
    final Future<dynamic> futureImageUrl = CalzadoService.obtenerImagen(
      item.producto.codigoBarras,
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
              child: FutureBuilder<dynamic>(
                future: futureImageUrl,
                builder: (context, imgSnapshot) {
                  if (imgSnapshot.connectionState == ConnectionState.waiting ||
                      imgSnapshot.connectionState == ConnectionState.active) {
                    return const Center(child: CircularProgressIndicator());
                  }
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

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.producto.modelo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    
                    children: [
                      Text(
                        'Precio: \$${item.producto.costo.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'Subtotal: \$${item.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                cartProvider.decrementar(
                                  item.producto.codigoBarras,
                                );
                              },
                              splashRadius: 20,
                              tooltip: 'Disminuir cantidad',
                            ),
                            Text(
                              '${item.cantidad.toInt()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                cartProvider.incrementar(
                                  item.producto.codigoBarras,
                                );
                              },
                              splashRadius: 20,
                              tooltip: 'Aumentar cantidad',
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red.shade700,
                        onPressed: () {
                          _confirmarEliminar(
                            context,
                            item.producto.codigoBarras,
                          );
                        },
                        tooltip: 'Eliminar producto',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, String codigoBarras) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('¿Eliminar producto?'),
            content: const Text(
              '¿Estás seguro de que deseas eliminar este producto del carrito?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  cartProvider.removeItem(codigoBarras);
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildTotalSection(
    BuildContext context,
    double totalMXN,
    int amountInCents,
  ) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalMXN.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _cargandoPago
                        ? null
                        : () async {
                          await _iniciarPago(context, amountInCents);
                        },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _cargandoPago
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          'Finalizar Compra',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _iniciarPago(BuildContext context, int amountInCents) async {
    setState(() {
      _cargandoPago = true;
    });

    try {
      // 1) Llamar al servicio que devuelve el clientSecret
      final clientSecret = await PaymentService.crearPaymentIntent(
        amountInCents,
      );

      // 2) Inicializar el Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Mi Tienda PakApp',
          style: ThemeMode.light,
        ),
      );

      // 3) Mostrar el Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // 4) Pago exitoso => mostrar mensaje y vaciar carrito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Pago exitoso! Gracias por tu compra.')),
      );
      Provider.of<CartProvider>(context, listen: false).clear();
    } on StripeException catch (e) {
      final mensaje =
          e.error.localizedMessage ?? 'Error en Stripe: ${e.error.code}';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        _cargandoPago = false;
      });
    }
  }
}
