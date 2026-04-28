class ExchangeRate {
  final int? id;
  final int fromId;
  final int toId;
  final double value;
  final DateTime updatedAt;

  ExchangeRate({
    this.id,
    required this.fromId,
    required this.toId,
    required this.value,
    required this.updatedAt,
  });

  ExchangeRate copyWith({
    int? id,
    int? fromId,
    int? toId,
    double? value,
    DateTime? updatedAt,
  }) {
    return ExchangeRate(
      id: id ?? this.id,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}