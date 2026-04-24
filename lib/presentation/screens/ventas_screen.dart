import 'package:dekkapos/presentation/widgets/dekka_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/cart_panel.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DekkaAppBar(title: 'Punto de Venta'),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Productos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Consumer<ProductProvider>(
                    builder: (context, provider, _) => TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar producto...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: provider.search,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Expanded(child: ProductGrid()),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(flex: 1, child: CartPanel()),
        ],
      ),
    );
  }
}
