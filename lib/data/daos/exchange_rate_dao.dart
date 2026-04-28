import 'package:drift/drift.dart';
import '../../domain/entities/exchange_rate.dart' as entity;
import '../app_database.dart';

class ExchangeRateDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(entity.ExchangeRate exchangeRate) async {
    return await _db.into(_db.exchangeRates).insert(
      ExchangeRatesCompanion.insert(
        fromId: exchangeRate.fromId,
        toId: exchangeRate.toId,
        value: exchangeRate.value,
        updatedAt: exchangeRate.updatedAt,
      ),
    );
  }

  Future<List<entity.ExchangeRate>> getAll() async {
    final results = await _db.select(_db.exchangeRates).get();
    return results.map(_exchangeRateFromRow).toList();
  }

  Future<entity.ExchangeRate?> getById(int id) async {
    final result = await (_db.select(_db.exchangeRates)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null ? _exchangeRateFromRow(result) : null;
  }

  Future<entity.ExchangeRate?> getByCurrencyPair(int fromId, int toId) async {
    final result = await (_db.select(_db.exchangeRates)
          ..where((t) => t.fromId.equals(fromId) & t.toId.equals(toId)))
        .getSingleOrNull();
    return result != null ? _exchangeRateFromRow(result) : null;
  }

  Future<int> update(entity.ExchangeRate exchangeRate) async {
    return await (_db.update(_db.exchangeRates)
          ..where((t) => t.id.equals(exchangeRate.id!)))
        .write(
      ExchangeRatesCompanion(
        fromId: Value(exchangeRate.fromId),
        toId: Value(exchangeRate.toId),
        value: Value(exchangeRate.value),
        updatedAt: Value(exchangeRate.updatedAt),
      ),
    );
  }

  Future<int> delete(int id) async {
    return await (_db.delete(_db.exchangeRates)..where((t) => t.id.equals(id)))
        .go();
  }

  entity.ExchangeRate _exchangeRateFromRow(ExchangeRateEnt row) {
    return entity.ExchangeRate(
      id: row.id,
      fromId: row.fromId,
      toId: row.toId,
      value: row.value,
      updatedAt: row.updatedAt,
    );
  }
}