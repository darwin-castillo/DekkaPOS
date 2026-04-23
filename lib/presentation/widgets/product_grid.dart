import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import 'product_weight_dialog.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final products = provider.filteredProducts;
        
        if (products.isEmpty) {
          return const Center(child: Text('No hay productos'));
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
            final isWeight = product.saleType == SaleType.weight;
            
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
                        isWeight ? Icons.kitchen : Icons.shopping_bag,
                        size: 32,
                        color: isWeight ? Colors.orange : Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isWeight ? Colors.orange.shade100 : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Bs ${product.priceBs.toStringAsFixed(0)}/${product.unit}',
                          style: TextStyle(
                            color: isWeight ? Colors.orange.shade700 : Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isWeight ? 'Por peso' : 'Unidad',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
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
    
    if (product.saleType == SaleType.weight) {
      showDialog(
        context: context,
        builder: (context) => ProductWeightDialog(product: product),
      );
    } else {
      cartProvider.addProduct(product);
    }
  }
}