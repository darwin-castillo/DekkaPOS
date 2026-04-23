import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'client_card.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Column(
              children: [
                const ClientCard(),
                const SizedBox(height: 12),
                Consumer<CartProvider>(
                  builder: (context, cart, _) => Card(
                    elevation: 4,
                    color: Colors.green.shade700,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text('TOTAL FACTURA', style: TextStyle(fontSize: 16, color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text(
                                'Bs ${cart.totalBs.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                '\$${cart.totalUsd.toStringAsFixed(2)} USD',
                                style: const TextStyle(fontSize: 18, color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text('Detalle de Venta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Cliente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: CartItemsList()),
          const CartActions(),
        ],
      ),
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        if (cart.items.isEmpty) {
          return const Center(
            child: Text('Carrito vacío\nAñada productos', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DataTable(
            columnSpacing: 12,
            columns: const [
              DataColumn(label: Text('Código', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Producto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Cant.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('')),
            ],
            rows: List.generate(cart.items.length, (index) {
              final item = cart.items[index];
              final esPeso = item.saleType == 'peso';
              return DataRow(cells: [
                DataCell(Text(item.code, style: const TextStyle(fontSize: 11))),
                DataCell(Text(item.name, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis)),
                DataCell(Text(
                  esPeso ? item.cantidad.toStringAsFixed(3) : item.cantidad.toInt().toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, color: esPeso ? Colors.orange : Colors.black),
                )),
                DataCell(Text('Bs ${item.totalBs.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                DataCell(IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () => cart.removeItem(index),
                )),
              ]);
            }),
          ),
        );
      },
    );
  }
}

class CartActions extends StatelessWidget {
  const CartActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.read<CartProvider>().clear(),
              icon: const Icon(Icons.cancel),
              label: const Text('CANCELAR'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('COBRAR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}