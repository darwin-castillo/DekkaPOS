import 'package:drift/drift.dart';
import '../../domain/entities/invoice_item.dart' as entity;
import '../app_database.dart';

class InvoiceItemDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(entity.InvoiceItem item) async {
    return await _db.into(_db.invoiceItems).insert(
      InvoiceItemsCompanion.insert(
        invoiceId: item.invoiceId,
        productoId: item.productoId,
        cantidad: Value(item.cantidad),
        precioUnitario: item.precioUnitario,
        discount: Value(item.discount),
        subtotal: Value(item.subtotal),
        totalSnapshot: Value(item.totalSnapshotJson.isEmpty ? null : item.totalSnapshotJson),
      ),
    );
  }

  Future<List<entity.InvoiceItem>> getByInvoiceId(int invoiceId) async {
    final results = await (_db.select(_db.invoiceItems)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .get();
    return results.map(_itemFromRow).toList();
  }

  Future<int> deleteByInvoiceId(int invoiceId) async {
    return await (_db.delete(_db.invoiceItems)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .go();
  }

  entity.InvoiceItem _itemFromRow(InvoiceItemEnt row) {
    return entity.InvoiceItem(
      id: row.id,
      invoiceId: row.invoiceId,
      productoId: row.productoId,
      cantidad: row.cantidad,
      precioUnitario: row.precioUnitario,
      discount: row.discount,
      subtotal: row.subtotal,
      totalSnapshot: entity.InvoiceItem.parseSnapshot(row.totalSnapshot),
    );
  }
}