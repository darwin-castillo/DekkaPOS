import 'package:flutter/foundation.dart';
import '../../data/daos/product_dao.dart';
import '../../domain/entities/product.dart';

class ProductProvider extends ChangeNotifier {
  final ProductDao _productDao = ProductDao();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Product> get products => List.unmodifiable(_products);
  List<Product> get filteredProducts => List.unmodifiable(_filteredProducts);
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    
    _products = await _productDao.getAll();
    _applyFilter();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((p) {
        final nameLower = p.name.toLowerCase();
        final codeLower = p.code.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return nameLower.contains(queryLower) || codeLower.contains(queryLower);
      }).toList();
    }
    notifyListeners();
  }

  Future<Product?> getById(int id) async {
    return await _productDao.getById(id);
  }

  Future<Product?> getByCode(String code) async {
    return await _productDao.getByCode(code);
  }

  Future<int> create(Product product) async {
    final id = await _productDao.create(product);
    await loadProducts();
    return id;
  }

  Future<void> update(Product product) async {
    await _productDao.update(product);
    await loadProducts();
  }

  Future<void> delete(int id) async {
    await _productDao.delete(id);
    await loadProducts();
  }

  Future<void> updateStock(int id, double newStock) async {
    await _productDao.updateStock(id, newStock);
    await loadProducts();
  }
}