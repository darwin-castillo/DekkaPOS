class CartItem {
  final String code;
  final String name;
  final double cantidad;
  final double precioBs;
  final double precioUsd;
  final String saleType;
  final String unit;

  const CartItem({
    required this.code,
    required this.name,
    required this.cantidad,
    required this.precioBs,
    required this.precioUsd,
    required this.saleType,
    required this.unit,
  });

  double get totalBs => precioBs * cantidad;
  double get totalUsd => precioUsd * cantidad;

  CartItem copyWith({
    String? code,
    String? name,
    double? cantidad,
    double? precioBs,
    double? precioUsd,
    String? saleType,
    String? unit,
  }) {
    return CartItem(
      code: code ?? this.code,
      name: name ?? this.name,
      cantidad: cantidad ?? this.cantidad,
      precioBs: precioBs ?? this.precioBs,
      precioUsd: precioUsd ?? this.precioUsd,
      saleType: saleType ?? this.saleType,
      unit: unit ?? this.unit,
    );
  }
}