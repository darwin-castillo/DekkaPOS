import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

import 'widgets/cart_panel.dart';
import '../../widgets/dekka_app_bar.dart';
import 'widgets/product_search_bar.dart';
import 'widgets/product_list_widget.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Punto de Venta',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: _ProductPanel(),
          ),
          Container(width: 1, color: Colors.grey.shade300),
          const Expanded(child: CartPanel()),
        ],
      ),
    );
  }
}

class _ProductPanel extends StatelessWidget {
  const _ProductPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.panelBg,
      child: Column(
        children: [
          Consumer<ProductProvider>(
            builder: (context, provider, _) =>
                ProductSearchBar(onChanged: provider.search),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                final products = provider.filteredProducts.isEmpty
                    ? provider.products
                    : provider.filteredProducts;
                return ProductListWidget(
                  products: products,
                  onProductTap: (product) =>
                      _handleProductTap(context, product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleProductTap(BuildContext context, Product product) {
    if (product.unit == SaleUnit.kilogramo) {
      _showWeightDialog(context, product);
    } else {
      context.read<CartProvider>().addProduct(product);
    }
  }

  void _showWeightDialog(BuildContext context, Product product) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product.name),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Peso (kg)',
            hintText: '0.500',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final peso = double.tryParse(controller.text);
              if (peso != null && peso > 0) {
                context.read<CartProvider>().addProductByWeight(product, peso);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
