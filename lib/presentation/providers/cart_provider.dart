import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalBs => _items.fold(0.0, (sum, item) => sum + item.totalBs);
  double get totalUsd => _items.fold(0.0, (sum, item) => sum + item.totalUsd);
  int get itemCount => _items.length;

  void addProduct(Product product) {
    final existingIndex = _items.indexWhere((item) => item.code == product.code);
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      final newCantidad = existing.cantidad + 1.0;
      _items[existingIndex] = existing.copyWith(cantidad: newCantidad);
    } else {
      _items.add(CartItem(
        code: product.code,
        name: product.name,
        cantidad: 1.0,
        precioBs: product.priceBs,
        precioUsd: product.priceUsd,
        saleType: product.saleType == SaleType.weight ? 'peso' : 'entero',
        unit: product.unit,
      ));
    }
    notifyListeners();
  }

  void addProductWithCantidad(Product product, double cantidad) {
    final existingIndex = _items.indexWhere((item) => item.code == product.code);
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      final newCantidad = existing.cantidad + cantidad;
      _items[existingIndex] = existing.copyWith(cantidad: newCantidad);
    } else {
      _items.add(CartItem(
        code: product.code,
        name: product.name,
        cantidad: cantidad,
        precioBs: product.priceBs,
        precioUsd: product.priceUsd,
        saleType: product.saleType == SaleType.weight ? 'peso' : 'entero',
        unit: product.unit,
      ));
    }
    notifyListeners();
  }

  void updateCantidad(int index, double cantidad) {
    if (index >= 0 && index < _items.length) {
      _items[index] = _items[index].copyWith(cantidad: cantidad);
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}