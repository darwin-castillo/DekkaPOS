import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductosScreen extends StatelessWidget {
  const ProductosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Nuevo Producto'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          final products = provider.products;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Código', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Categoría', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Precio', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: products.map((p) => DataRow(cells: [
                DataCell(Text(p.code)),
                DataCell(Text(p.name)),
                DataCell(Text(p.category)),
                DataCell(Text('Bs ${p.priceBs.toStringAsFixed(0)}')),
                DataCell(Text('${p.stock}')),
                const DataCell(Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: Colors.blue),
                    SizedBox(width: 8),
                    Icon(Icons.delete, size: 20, color: Colors.red),
                  ],
                )),
              ])).toList(),
            ),
          );
        },
      ),
    );
  }
}