import 'dart:convert';

class InvoiceItem {
  final int? id;
  final int invoiceId;
  final int productoId;
  final double cantidad;
  final double precioUnitario;
  final double discount;
  final double subtotal;
  final Map<String, double>? totalSnapshot;

  InvoiceItem({
    this.id,
    required this.invoiceId,
    required this.productoId,
    this.cantidad = 1,
    required this.precioUnitario,
    this.discount = 0,
    this.subtotal = 0,
    this.totalSnapshot,
  });

  InvoiceItem copyWith({
    int? id,
    int? invoiceId,
    int? productoId,
    double? cantidad,
    double? precioUnitario,
    double? discount,
    double? subtotal,
    Map<String, double>? totalSnapshot,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      discount: discount ?? this.discount,
      subtotal: subtotal ?? this.subtotal,
      totalSnapshot: totalSnapshot ?? this.totalSnapshot,
    );
  }

  String get totalSnapshotJson =>
      totalSnapshot != null ? jsonEncode(totalSnapshot) : '';

  static Map<String, double>? parseSnapshot(String? json) {
    if (json == null || json.isEmpty) return null;
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }
}