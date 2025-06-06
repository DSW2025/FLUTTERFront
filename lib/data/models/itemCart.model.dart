import 'package:pakapp/data/models/calzadoAdmin.model.dart';

class CartItem {
  final CalzadoModel producto;
  double cantidad;

  CartItem({required this.producto, this.cantidad = 1});

  double get subtotal => producto.costo * cantidad;
}