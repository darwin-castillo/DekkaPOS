import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/cart_provider.dart';

class ProductWeightDialog extends StatefulWidget {
  final Product product;

  const ProductWeightDialog({super.key, required this.product});

  @override
  State<ProductWeightDialog> createState() => _ProductWeightDialogState();
}

class _ProductWeightDialogState extends State<ProductWeightDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ingresar cantidad - ${widget.product.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Precio: Bs ${widget.product.priceBs.toStringAsFixed(0)} / ${widget.product.unit}'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Cantidad (${widget.product.unit})',
              hintText: 'Ej: 1.5',
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _addProduct,
          child: const Text('Agregar'),
        ),
      ],
    );
  }

  void _addProduct() {
    final cantidad = double.tryParse(_controller.text);
    if (cantidad != null && cantidad > 0) {
      context.read<CartProvider>().addProductWithCantidad(widget.product, cantidad);
      Navigator.pop(context);
    }
  }
}