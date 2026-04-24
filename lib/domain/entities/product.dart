enum SaleUnit {
  unitario('und', 'Unitario'),
  kilogramo('kg', 'Kilogramo');

  final String code;
  final String label;
  const SaleUnit(this.code, this.label);

  static SaleUnit fromCode(String code) {
    return SaleUnit.values.firstWhere(
      (u) => u.code == code,
      orElse: () => SaleUnit.unitario,
    );
  }
}

class Product {
  final int? id;
  final String name;
  final String? description;
  final String code;
  final int? idCategory;
  final int? idProvider;
  final double cost;
  final double price;
  final double stock;
  final double discount;
  final SaleUnit unit;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.code,
    this.idCategory,
    this.idProvider,
    this.cost = 0,
    required this.price,
    this.stock = 0,
    this.discount = 0,
    this.unit = SaleUnit.unitario,
  });

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? code,
    int? idCategory,
    int? idProvider,
    double? cost,
    double? price,
    double? stock,
    double? discount,
    SaleUnit? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      idCategory: idCategory ?? this.idCategory,
      idProvider: idProvider ?? this.idProvider,
      cost: cost ?? this.cost,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      discount: discount ?? this.discount,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'id_category': idCategory,
      'id_provider': idProvider,
      'cost': cost,
      'price': price,
      'stock': stock,
      'discount': discount,
      'unit': unit.code,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      code: map['code'] as String,
      idCategory: map['id_category'] as int?,
      idProvider: map['id_provider'] as int?,
      cost: (map['cost'] as num).toDouble(),
      price: (map['price'] as num).toDouble(),
      stock: (map['stock'] as num).toDouble(),
      discount: (map['discount'] as num).toDouble(),
      unit: SaleUnit.fromCode(map['unit'] as String? ?? 'und'),
    );
  }
}