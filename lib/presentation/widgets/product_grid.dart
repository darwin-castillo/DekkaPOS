import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final products = provider.filteredProducts;
        
        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('No hay productos', style: TextStyle(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isKg = product.unit == SaleUnit.kilogramo;
            
            return Card(
              elevation: 2,
              child: InkWell(
                onTap: () => _handleTap(context, product),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isKg ? Icons.scale : Icons.shopping_bag,
                        size: 32,
                        color: isKg ? colorScheme.tertiary : colorScheme.primary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: colorScheme.onSurface),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isKg ? colorScheme.tertiaryContainer : colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Bs ${product.price.toStringAsFixed(0)}/${product.unit.code}',
                          style: TextStyle(
                            color: isKg ? colorScheme.onTertiaryContainer : colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isKg ? 'Por peso' : 'Unidad',
                        style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleTap(BuildContext context, Product product) {
    final cartProvider = context.read<CartProvider>();
    
    if (product.unit == SaleUnit.kilogramo) {
      showDialog(
        context: context,
        builder: (context) => _WeightDialog(product: product),
      );
    } else {
      cartProvider.addProduct(product);
    }
  }
}

class _WeightDialog extends StatefulWidget {
  final Product product;
  const _WeightDialog({required this.product});

  @override
  State<_WeightDialog> createState() => _WeightDialogState();
}

class _WeightDialogState extends State<_WeightDialog> {
  final _controller = TextEditingController();
  double _weight = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = _weight * widget.product.price;

    return AlertDialog(
      title: Text(widget.product.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bs ${widget.product.price.toStringAsFixed(2)} / kg'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
              hintText: '0.000',
            ),
            onChanged: (v) {
              setState(() {
                _weight = double.tryParse(v) ?? 0;
              });
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total: ', style: TextStyle(color: colorScheme.onPrimaryContainer)),
                Text(
                  'Bs ${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _weight > 0
              ? () {
                  context.read<CartProvider>().addProductByWeight(widget.product, _weight);
                  Navigator.pop(context);
                }
              : null,
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}