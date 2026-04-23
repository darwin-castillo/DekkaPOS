enum SaleType { unit, weight }

class Product {
  final String code;
  final String name;
  final String category;
  final double priceBs;
  final double priceUsd;
  final int stock;
  final SaleType saleType;
  final String unit;

  const Product({
    required this.code,
    required this.name,
    required this.category,
    required this.priceBs,
    required this.priceUsd,
    required this.stock,
    required this.saleType,
    required this.unit,
  });

  Product copyWith({
    String? code,
    String? name,
    String? category,
    double? priceBs,
    double? priceUsd,
    int? stock,
    SaleType? saleType,
    String? unit,
  }) {
    return Product(
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      priceBs: priceBs ?? this.priceBs,
      priceUsd: priceUsd ?? this.priceUsd,
      stock: stock ?? this.stock,
      saleType: saleType ?? this.saleType,
      unit: unit ?? this.unit,
    );
  }
}