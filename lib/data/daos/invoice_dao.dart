import 'package:drift/drift.dart';
import '../../domain/entities/invoice.dart' as entity;
import '../app_database.dart';

class InvoiceDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(entity.Invoice invoice) async {
    return await _db.into(_db.invoices).insert(
      InvoicesCompanion.insert(
        numero: invoice.numero,
        fecha: invoice.fecha,
        clienteId: Value(invoice.clienteId),
        subtotal: Value(invoice.subtotal),
        tax: Value(invoice.tax),
        discount: Value(invoice.discount),
        total: Value(invoice.total),
        baseCurrencyId: invoice.baseCurrencyId,
        metodoPago: Value(invoice.metodoPago),
        status: Value(invoice.status),
        totalSnapshot: Value(invoice.totalSnapshotJson.isEmpty ? null : invoice.totalSnapshotJson),
        createdAt: invoice.createdAt,
      ),
    );
  }

  Future<List<entity.Invoice>> getAll() async {
    final results = await (_db.select(_db.invoices)..orderBy([(t) => OrderingTerm.desc(t.fecha)])).get();
    return results.map(_invoiceFromRow).toList();
  }

  Future<entity.Invoice?> getById(int id) async {
    final result = await (_db.select(_db.invoices)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null ? _invoiceFromRow(result) : null;
  }

  Future<entity.Invoice?> getByNumero(String numero) async {
    final result = await (_db.select(_db.invoices)
          ..where((t) => t.numero.equals(numero)))
        .getSingleOrNull();
    return result != null ? _invoiceFromRow(result) : null;
  }

  Future<String> getNextNumero() async {
    final results = await (_db.select(_db.invoices)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    
    if (results == null) {
      return '0001';
    }
    
    final lastNumero = int.tryParse(results.numero) ?? 0;
    return (lastNumero + 1).toString().padLeft(4, '0');
  }

  Future<List<entity.Invoice>> getByStatus(String status) async {
    final results = await (_db.select(_db.invoices)
          ..where((t) => t.status.equals(status))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .get();
    return results.map(_invoiceFromRow).toList();
  }

  Future<int> update(entity.Invoice invoice) async {
    return await (_db.update(_db.invoices)
          ..where((t) => t.id.equals(invoice.id!)))
        .write(
      InvoicesCompanion(
        numero: Value(invoice.numero),
        fecha: Value(invoice.fecha),
        clienteId: Value(invoice.clienteId),
        subtotal: Value(invoice.subtotal),
        tax: Value(invoice.tax),
        discount: Value(invoice.discount),
        total: Value(invoice.total),
        baseCurrencyId: Value(invoice.baseCurrencyId),
        metodoPago: Value(invoice.metodoPago),
        status: Value(invoice.status),
        totalSnapshot: Value(invoice.totalSnapshotJson.isEmpty ? null : invoice.totalSnapshotJson),
      ),
    );
  }

  Future<int> updateStatus(int id, String status) async {
    return await (_db.update(_db.invoices)
          ..where((t) => t.id.equals(id)))
        .write(
      InvoicesCompanion(status: Value(status)),
    );
  }

  Future<int> delete(int id) async {
    return await (_db.delete(_db.invoices)..where((t) => t.id.equals(id)))
        .go();
  }

  entity.Invoice _invoiceFromRow(InvoiceEnt row) {
    return entity.Invoice(
      id: row.id,
      numero: row.numero,
      fecha: row.fecha,
      clienteId: row.clienteId,
      subtotal: row.subtotal,
      tax: row.tax,
      discount: row.discount,
      total: row.total,
      baseCurrencyId: row.baseCurrencyId,
      metodoPago: row.metodoPago,
      status: row.status,
      totalSnapshot: entity.Invoice.parseSnapshot(row.totalSnapshot),
      createdAt: row.createdAt,
    );
  }
}