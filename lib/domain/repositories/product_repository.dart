import '../entities/product.dart';

abstract class ProductRepository {
  List<Product> getAllProducts();
  List<Product> getProductsByCategory(String category);
  List<Product> searchProducts(String query);
  Product? getProductByCode(String code);
  void updateStock(String code, int newStock);
}