import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';
import '../widgets/dekka_app_bar.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const DekkaAppBar(
        title: 'Productos',
        userName: 'Administrador',
        userEmail: 'admin@dekkapos.com',
        userInitial: 'A',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = provider.products;

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No hay productos', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showProductDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar producto'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              final isKg = p.unit == SaleUnit.kilogramo;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isKg ? colorScheme.tertiaryContainer : colorScheme.primaryContainer,
                    child: Icon(
                      isKg ? Icons.scale : Icons.shopping_bag,
                      color: isKg ? colorScheme.onTertiaryContainer : colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(p.name),
                  subtitle: Text('Código: ${p.code} • Stock: ${p.stock.toStringAsFixed(isKg ? 3 : 0)} ${p.unit.label}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Bs ${p.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorScheme.primary),
                        onPressed: () => _showProductDialog(context, product: p),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: colorScheme.error),
                        onPressed: () => _confirmDelete(context, p.id!, p.name),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showProductDialog(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      builder: (context) => ProductFormDialog(product: product),
    );
  }

  void _confirmDelete(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Eliminar "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<ProductProvider>().delete(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _codeController;
  late final TextEditingController _costController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _discountController;
  late SaleUnit _selectedUnit;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _codeController = TextEditingController(text: widget.product?.code ?? '');
    _costController = TextEditingController(text: widget.product?.cost.toString() ?? '0');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '0');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '0');
    _discountController = TextEditingController(text: widget.product?.discount.toString() ?? '0');
    _selectedUnit = widget.product?.unit ?? SaleUnit.unitario;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar producto' : 'Nuevo producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Código *'),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descripción')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _costController, decoration: const InputDecoration(labelText: 'Costo'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Precio *'), keyboardType: TextInputType.number, validator: (v) => v?.isEmpty == true ? 'Requerido' : null)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _stockController, decoration: InputDecoration(labelText: 'Stock (${_selectedUnit.label})'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(controller: _discountController, decoration: const InputDecoration(labelText: 'Descuento %'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<SaleUnit>(
                initialValue: _selectedUnit,
                decoration: const InputDecoration(labelText: 'Tipo de unidad'),
                items: SaleUnit.values.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Row(
                      children: [
                        Icon(unit == SaleUnit.unitario ? Icons.shopping_bag : Icons.scale, size: 20),
                        const SizedBox(width: 8),
                        Text(unit.label),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedUnit = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _save, child: Text(isEditing ? 'Guardar' : 'Crear')),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ProductProvider>();
    final product = Product(
      id: widget.product?.id,
      name: _nameController.text,
      description: _descriptionController.text,
      code: _codeController.text,
      cost: double.tryParse(_costController.text) ?? 0,
      price: double.parse(_priceController.text),
      stock: double.tryParse(_stockController.text) ?? 0,
      discount: double.tryParse(_discountController.text) ?? 0,
      unit: _selectedUnit,
    );
    if (isEditing) {
      await provider.update(product);
    } else {
      await provider.create(product);
    }
    if (mounted) Navigator.pop(context);
  }
}