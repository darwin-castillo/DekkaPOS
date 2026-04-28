import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';

class CartItem {
  final int productId;
  final String code;
  final String name;
  final double cantidad;
  final double precio;
  final SaleUnit unit;
  final double discount;

  CartItem({
    required this.productId,
    required this.code,
    required this.name,
    required this.cantidad,
    required this.precio,
    this.unit = SaleUnit.unitario,
    this.discount = 0,
  });

  double get total => cantidad * precio;
  double get totalWithDiscount => total - (total * discount / 100);

  CartItem copyWith({
    int? productId,
    String? code,
    String? name,
    double? cantidad,
    double? precio,
    SaleUnit? unit,
    double? discount,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      code: code ?? this.code,
      name: name ?? this.name,
      cantidad: cantidad ?? this.cantidad,
      precio: precio ?? this.precio,
      unit: unit ?? this.unit,
      discount: discount ?? this.discount,
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _clienteId;
  String _metodoPago = 'efectivo';

  List<CartItem> get items => List.unmodifiable(_items);
  String? get clienteId => _clienteId;
  String get metodoPago => _metodoPago;

  double get totalBs => _items.fold(0.0, (sum, item) => sum + item.totalWithDiscount);
  int get itemCount => _items.length;

  void setClienteId(String? id) {
    _clienteId = id;
    notifyListeners();
  }

  void setMetodoPago(String metodo) {
    _metodoPago = metodo;
    notifyListeners();
  }

  void addProduct(Product product) {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      final newCantidad = existing.cantidad + 1;
      _items[existingIndex] = existing.copyWith(cantidad: newCantidad);
    } else {
      _items.add(CartItem(
        productId: product.id!,
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
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      final newCantidad = existing.cantidad + weight;
      _items[existingIndex] = existing.copyWith(cantidad: newCantidad);
    } else {
      _items.add(CartItem(
        productId: product.id!,
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

  void updateDiscount(int index, double discount) {
    if (index >= 0 && index < _items.length) {
      _items[index] = _items[index].copyWith(discount: discount);
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
    _clienteId = null;
    _metodoPago = 'efectivo';
    notifyListeners();
  }
}