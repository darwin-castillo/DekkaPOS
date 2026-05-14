import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            child: const _ProductPanel(),
          ),
          Container(width: 1, color: Colors.grey.shade300),
          const Expanded(child: CartPanel()),
        ],
      ),
    );
  }
}

class _ProductPanel extends StatefulWidget {
  const _ProductPanel();

  @override
  State<_ProductPanel> createState() => _ProductPanelState();
}

class _ProductPanelState extends State<_ProductPanel> {
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _handleKeyEvent(event),
      child: Container(
        color: AppColors.panelBg,
        child: Column(
          children: [
            Consumer<ProductProvider>(
              builder: (context, provider, _) => ProductSearchBar(
                onChanged: (value) {
                  provider.search(value);
                  setState(() => _selectedIndex = -1);
                },
                focusNode: _searchFocusNode,
              ),
            ),
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  final products = provider.filteredProducts.isEmpty
                      ? provider.products
                      : provider.filteredProducts;
                  return ProductListWidget(
                    products: products,
                    selectedIndex: _selectedIndex,
                    onProductTap: (product) =>
                        _handleProductTap(context, product),
                  );
                },
              ),
            ),
            _buildKeyboardHint(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.mainBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _keyHint('↑↓', 'Navegar'),
          const SizedBox(width: 16),
          _keyHint('Enter', 'Seleccionar'),
          const SizedBox(width: 16),
          _keyHint('Esc', 'Limpiar'),
        ],
      ),
    );
  }

  Widget _keyHint(String key, String action) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            key,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          action,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
      ],
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (!mounted) return KeyEventResult.ignored;

    final provider = context.read<ProductProvider>();
    final products = provider.filteredProducts.isEmpty
        ? provider.products
        : provider.filteredProducts;

    if (products.isEmpty) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % products.length;
        });
        break;
      case LogicalKeyboardKey.arrowUp:
        setState(() {
          _selectedIndex = _selectedIndex <= 0
              ? products.length - 1
              : _selectedIndex - 1;
        });
        break;
      case LogicalKeyboardKey.enter:
        if (_selectedIndex >= 0 && _selectedIndex < products.length) {
          _handleProductTap(context, products[_selectedIndex]);
        } else if (products.isNotEmpty) {
          setState(() => _selectedIndex = 0);
        }
        break;
      case LogicalKeyboardKey.escape:
        provider.search('');
        _searchFocusNode.requestFocus();
        setState(() => _selectedIndex = -1);
        break;
      case LogicalKeyboardKey.tab:
        _searchFocusNode.requestFocus();
        setState(() => _selectedIndex = -1);
        break;
      case LogicalKeyboardKey.f2:
        _searchFocusNode.requestFocus();
        setState(() => _selectedIndex = -1);
        break;
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _handleProductTap(BuildContext context, Product product) {
    _showQuantityDialog(context, product);
  }

  void _showQuantityDialog(BuildContext context, Product product) {
    final controller = TextEditingController();

    if (product.unit == SaleUnit.kilogramo) {
      controller.text = '0.500';
    } else {
      controller.text = '1';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bs ${product.price.toStringAsFixed(2)} / ${product.unit.label}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: product.unit == SaleUnit.kilogramo
                    ? 'Peso (kg)'
                    : 'Cantidad',
                hintText: product.unit == SaleUnit.kilogramo ? '0.500' : '1',
              ),
              autofocus: true,
              onSubmitted: (value) =>
                  _addProduct(ctx, product, controller.text),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _addProduct(ctx, product, controller.text),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _addProduct(BuildContext dialogContext, Product product, String value) {
    final cart = context.read<CartProvider>();

    if (product.unit == SaleUnit.kilogramo) {
      final peso = double.tryParse(value);
      if (peso != null && peso > 0) {
        cart.addProductByWeight(product, peso);
      }
    } else {
      final qty = int.tryParse(value);
      if (qty != null && qty > 0) {
        for (int i = 0; i < qty; i++) {
          cart.addProduct(product);
        }
      }
    }

    Navigator.pop(dialogContext);
    _returnFocusToSearch();
  }

  void _returnFocusToSearch() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _searchFocusNode.requestFocus();
        setState(() => _selectedIndex = -1);
      }
    });
  }
}
