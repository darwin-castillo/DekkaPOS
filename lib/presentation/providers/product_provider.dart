import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';

  ProductProvider(this._repository) {
    loadProducts();
  }

  List<Product> get products => List.unmodifiable(_products);
  List<Product> get filteredProducts => List.unmodifiable(_filteredProducts);

  void loadProducts() {
    _products = _repository.getAllProducts();
    _applyFilter();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _repository.searchProducts(_searchQuery);
    }
    notifyListeners();
  }

  Product? getProductByCode(String code) {
    return _repository.getProductByCode(code);
  }

  void updateStock(String code, int newStock) {
    _repository.updateStock(code, newStock);
    loadProducts();
  }
}