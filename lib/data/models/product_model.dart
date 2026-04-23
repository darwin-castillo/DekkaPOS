import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.code,
    required super.name,
    required super.category,
    required super.priceBs,
    required super.priceUsd,
    required super.stock,
    required super.saleType,
    required super.unit,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      code: json['codigo'] as String,
      name: json['nombre'] as String,
      category: json['categoria'] as String,
      priceBs: (json['precioBs'] as num).toDouble(),
      priceUsd: (json['precioUsd'] as num).toDouble(),
      stock: json['stock'] as int,
      saleType: json['tipoVenta'] == 'peso' ? SaleType.weight : SaleType.unit,
      unit: json['umedida'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': code,
      'nombre': name,
      'categoria': category,
      'precioBs': priceBs,
      'precioUsd': priceUsd,
      'stock': stock,
      'tipoVenta': saleType == SaleType.weight ? 'peso' : 'entero',
      'umedida': unit,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      code: product.code,
      name: product.name,
      category: product.category,
      priceBs: product.priceBs,
      priceUsd: product.priceUsd,
      stock: product.stock,
      saleType: product.saleType,
      unit: product.unit,
    );
  }
}