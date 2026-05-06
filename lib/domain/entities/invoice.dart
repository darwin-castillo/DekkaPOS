import 'dart:convert';

class Invoice {
  final int? id;
  final String numero;
  final DateTime fecha;
  final int? clienteId;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final int baseCurrencyId;
  final String metodoPago;
  final String status;
  final Map<String, double>? totalSnapshot;
  final DateTime createdAt;

  Invoice({
    this.id,
    required this.numero,
    required this.fecha,
    this.clienteId,
    this.subtotal = 0,
    this.tax = 0,
    this.discount = 0,
    this.total = 0,
    required this.baseCurrencyId,
    this.metodoPago = 'efectivo',
    this.status = 'pendiente',
    this.totalSnapshot,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Invoice copyWith({
    int? id,
    String? numero,
    DateTime? fecha,
    int? clienteId,
    double? subtotal,
    double? tax,
    double? discount,
    double? total,
    int? baseCurrencyId,
    String? metodoPago,
    String? status,
    Map<String, double>? totalSnapshot,
    DateTime? createdAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      fecha: fecha ?? this.fecha,
      clienteId: clienteId ?? this.clienteId,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      baseCurrencyId: baseCurrencyId ?? this.baseCurrencyId,
      metodoPago: metodoPago ?? this.metodoPago,
      status: status ?? this.status,
      totalSnapshot: totalSnapshot ?? this.totalSnapshot,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get totalSnapshotJson {
    if (totalSnapshot == null) return '';
    return jsonEncode(totalSnapshot);
  }

  static Map<String, double>? parseSnapshot(String? json) {
    if (json == null || json.isEmpty) return null;
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }
}