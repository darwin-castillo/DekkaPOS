import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';

class CartItem {
  final String code;
  final String name;
  final double cantidad;
  final double precio;
  final SaleUnit unit;

  CartItem({
    required this.code,
    required this.name,
    required this.cantidad,
    required this.precio,
    this.unit = SaleUnit.unitario,
  });

  double get total => cantidad * precio;

  CartItem copyWith({
    String? code,
    String? name,
    double? cantidad,
    double? precio,
    SaleUnit? unit,
  }) {
    return CartItem(
      code: code ?? this.code,
      name: name ?? this.name,
      cantidad: cantidad ?? this.cantidad,
      precio: precio ?? this.precio,
      unit: unit ?? this.unit,
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalBs => _items.fold(0.0, (sum, item) => sum + item.total);
  int get itemCount => _items.length;

  void addProduct(Product product) {
    final existingIndex = _items.indexWhere((item) => item.code == product.code);
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      final newCantidad = existing.cantidad + 1;
      _items[existingIndex] = existing.copyWith(cantidad: newCantidad);
    } else {
      _items.add(CartItem(
        code: product.code,
        name: product.name,
        cantidad: 1,
        precio: product.price,
        unit: product.unit,
      ));
    }
    notifyListeners();
  }

  void addProductByWeight(Product product, double weight) {
    final existingIndex = _items.indexWhere((item) => item.code == product.code);
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      final newCantidad = existing.cantidad + weight;
      _items[existingIndex] = existing.copyWith(cantidad: newCantidad);
    } else {
      _items.add(CartItem(
        code: product.code,
        name: product.name,
        cantidad: weight,
        precio: product.price,
        unit: SaleUnit.kilogramo,
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