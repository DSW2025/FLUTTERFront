import 'package:flutter/material.dart';
import 'package:pakapp/data/models/itemCode.model.dart';

class CartaCodigoBarras extends StatelessWidget {
  final ItemCodigo item;
  final VoidCallback onChanged; // Para notificar cambios

  const CartaCodigoBarras({
    super.key,
    required this.item,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.codigo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.cantidad}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      item.cantidad++;
                      onChanged(); // 👈 avisa que cambió
                    },
                    child: const Icon(Icons.keyboard_arrow_up, size: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (item.cantidad > 0) {
                        item.cantidad--;
                        onChanged();
                      }
                    },
                    child: const Icon(Icons.keyboard_arrow_down, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
