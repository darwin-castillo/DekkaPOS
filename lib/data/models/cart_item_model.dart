import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.code,
    required super.name,
    required super.cantidad,
    required super.precioBs,
    required super.precioUsd,
    required super.saleType,
    required super.unit,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      code: json['codigo'] as String,
      name: json['nombre'] as String,
      cantidad: (json['cantidad'] as num).toDouble(),
      precioBs: (json['precioBs'] as num).toDouble(),
      precioUsd: (json['precioUsd'] as num).toDouble(),
      saleType: json['tipoVenta'] as String,
      unit: json['umedida'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': code,
      'nombre': name,
      'cantidad': cantidad,
      'precioBs': precioBs,
      'precioUsd': precioUsd,
      'tipoVenta': saleType,
      'umedida': unit,
    };
  }

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      code: item.code,
      name: item.name,
      cantidad: item.cantidad,
      precioBs: item.precioBs,
      precioUsd: item.precioUsd,
      saleType: item.saleType,
      unit: item.unit,
    );
  }
}