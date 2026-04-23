import '../../domain/entities/product.dart';
import '../models/product_model.dart';

class LocalProductDataSource {
  static final List<ProductModel> _products = [
    ProductModel(
      code: 'PRD001',
      name: 'Coca Cola 500ml',
      category: 'Bebidas',
      priceBs: 15000,
      priceUsd: 1.75,
      stock: 50,
      saleType: SaleType.unit,
      unit: 'unid',
    ),
    ProductModel(
      code: 'PRD002',
      name: 'Agua Mineral 1L',
      category: 'Bebidas',
      priceBs: 8000,
      priceUsd: 0.93,
      stock: 100,
      saleType: SaleType.unit,
      unit: 'unid',
    ),
    ProductModel(
      code: 'PRD003',
      name: 'Jugo Natural',
      category: 'Bebidas',
      priceBs: 22000,
      priceUsd: 2.55,
      stock: 35,
      saleType: SaleType.unit,
      unit: 'unid',
    ),
    ProductModel(
      code: 'PRD004',
      name: 'Cerveza Pola',
      category: 'Bebidas',
      priceBs: 18000,
      priceUsd: 2.10,
      stock: 60,
      saleType: SaleType.unit,
      unit: 'unid',
    ),
    ProductModel(
      code: 'PRD011',
      name: 'Queso Mozzarella',
      category: 'Charcutería',
      priceBs: 500000,
      priceUsd: 58.00,
      stock: 15,
      saleType: SaleType.weight,
      unit: 'kg',
    ),
    ProductModel(
      code: 'PRD012',
      name: 'Jamón Paleta',
      category: 'Charcutería',
      priceBs: 350000,
      priceUsd: 40.50,
      stock: 20,
      saleType: SaleType.weight,
      unit: 'kg',
    ),
    ProductModel(
      code: 'PRD013',
      name: 'Tocino',
      category: 'Charcutería',
      priceBs: 280000,
      priceUsd: 32.50,
      stock: 12,
      saleType: SaleType.weight,
      unit: 'kg',
    ),
    ProductModel(
      code: 'PRD014',
      name: 'Queso Amarillo',
      category: 'Charcutería',
      priceBs: 420000,
      priceUsd: 48.80,
      stock: 18,
      saleType: SaleType.weight,
      unit: 'kg',
    ),
    ProductModel(
      code: 'PRD015',
      name: 'Mortadela',
      category: 'Charcutería',
      priceBs: 180000,
      priceUsd: 20.90,
      stock: 25,
      saleType: SaleType.weight,
      unit: 'kg',
    ),
    ProductModel(
      code: 'PRD016',
      name: 'Salchicha Vienesa',
      category: 'Charcutería',
      priceBs: 150000,
      priceUsd: 17.40,
      stock: 30,
      saleType: SaleType.weight,
      unit: 'kg',
    ),
    ProductModel(
      code: 'PRD021',
      name: 'Leche Entera',
      category: 'Lácteos',
      priceBs: 25000,
      priceUsd: 2.90,
      stock: 80,
      saleType: SaleType.unit,
      unit: 'unid',
    ),
    ProductModel(
      code: 'PRD022',
      name: 'Yogurt',
      category: 'Lácteos',
      priceBs: 18000,
      priceUsd: 2.10,
      stock: 45,
      saleType: SaleType.unit,
      unit: 'unid',
    ),
  ];

  List<Product> getAll() => List.unmodifiable(_products);

  Product? getByCode(String code) {
    try {
      return _products.firstWhere((p) => p.code == code);
    } catch (_) {
      return null;
    }
  }

  List<Product> search(String query) {
    final lowerQuery = query.toLowerCase();
    return _products.where((p) =>
      p.name.toLowerCase().contains(lowerQuery) ||
      p.code.toLowerCase().contains(lowerQuery) ||
      p.category.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Product> getByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  void updateStock(String code, int newStock) {
    final index = _products.indexWhere((p) => p.code == code);
    if (index != -1) {
      _products[index] = ProductModel(
        code: _products[index].code,
        name: _products[index].name,
        category: _products[index].category,
        priceBs: _products[index].priceBs,
        priceUsd: _products[index].priceUsd,
        stock: newStock,
        saleType: _products[index].saleType,
        unit: _products[index].unit,
      );
    }
  }
}