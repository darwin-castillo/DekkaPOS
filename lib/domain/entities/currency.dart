class Currency {
  final int? id;
  final String code;
  final String symbol;
  final String name;
  final bool isBase;

  Currency({
    this.id,
    required this.code,
    required this.symbol,
    required this.name,
    this.isBase = false,
  });

  Currency copyWith({
    int? id,
    String? code,
    String? symbol,
    String? name,
    bool? isBase,
  }) {
    return Currency(
      id: id ?? this.id,
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      isBase: isBase ?? this.isBase,
    );
  }
}