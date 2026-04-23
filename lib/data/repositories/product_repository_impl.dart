import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local_product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final LocalProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  List<Product> getAllProducts() {
    return _dataSource.getAll();
  }

  @override
  List<Product> getProductsByCategory(String category) {
    return _dataSource.getByCategory(category);
  }

  @override
  List<Product> searchProducts(String query) {
    return _dataSource.search(query);
  }

  @override
  Product? getProductByCode(String code) {
    return _dataSource.getByCode(code);
  }

  @override
  void updateStock(String code, int newStock) {
    _dataSource.updateStock(code, newStock);
  }
}