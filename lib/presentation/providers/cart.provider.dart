import 'package:flutter/material.dart';
import 'package:pakapp/data/models/calzadoAdmin.model.dart';
import 'package:pakapp/data/models/itemCart.model.dart';

class CartProvider extends ChangeNotifier {
  // Usaremos un Map<String, CartItem> con clave = código de barras
  // para evitar duplicados de un mismo modelo.
  final Map<String, CartItem> _items = {};

  /// Devuelve todos los ítems del carrito como lista.
  List<CartItem> get items => _items.values.toList();

  /// Devuelve el total del carrito.
  double get total {
    return _items.values.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Agrega un producto al carrito. Si ya existe, suma la cantidad.
  void addItem(CalzadoModel producto, int cantidad) {
    if (_items.containsKey(producto.codigoBarras)) {
      _items[producto.codigoBarras]!.cantidad += cantidad;
    } else {
      _items[producto.codigoBarras] = CartItem(
        producto: producto,
        cantidad: cantidad.toDouble(),
      );
    }
    notifyListeners();
  }

  /// Incrementa la cantidad de un ítem (por código de barras).
  void incrementar(String codigoBarras) {
    if (_items.containsKey(codigoBarras)) {
      _items[codigoBarras]!.cantidad++;
      notifyListeners();
    }
  }

  /// Decrementa la cantidad de un ítem (solo si > 1).
  void decrementar(String codigoBarras) {
    if (_items.containsKey(codigoBarras) &&
        _items[codigoBarras]!.cantidad > 1) {
      _items[codigoBarras]!.cantidad--;
      notifyListeners();
    }
  }

  /// Elimina por completo un ítem del carrito.
  void removeItem(String codigoBarras) {
    if (_items.containsKey(codigoBarras)) {
      _items.remove(codigoBarras);
      notifyListeners();
    }
  }

  /// Limpia todo el carrito.
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
