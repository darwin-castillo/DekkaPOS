import 'package:drift/drift.dart';
import '../../domain/entities/currency.dart' as entity;
import '../app_database.dart';

class CurrencyDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(entity.Currency currency) async {
    return await _db.into(_db.currencies).insert(
      CurrenciesCompanion.insert(
        code: currency.code,
        symbol: currency.symbol,
        name: currency.name,
        isBase: Value(currency.isBase),
      ),
    );
  }

  Future<List<entity.Currency>> getAll() async {
    final results = await _db.select(_db.currencies).get();
    return results.map(_currencyFromRow).toList();
  }

  Future<entity.Currency?> getById(int id) async {
    final result = await (_db.select(_db.currencies)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null ? _currencyFromRow(result) : null;
  }

  Future<entity.Currency?> getByCode(String code) async {
    final result = await (_db.select(_db.currencies)
          ..where((t) => t.code.equals(code)))
        .getSingleOrNull();
    return result != null ? _currencyFromRow(result) : null;
  }

  Future<entity.Currency?> getBaseCurrency() async {
    final result = await (_db.select(_db.currencies)
          ..where((t) => t.isBase.equals(true)))
        .getSingleOrNull();
    return result != null ? _currencyFromRow(result) : null;
  }

  Future<int> setBaseCurrency(int id) async {
    await _db.update(_db.currencies).write(
      const CurrenciesCompanion(isBase: Value(false)),
    );
    return await (_db.update(_db.currencies)
          ..where((t) => t.id.equals(id)))
        .write(
      const CurrenciesCompanion(isBase: Value(true)),
    );
  }

  Future<int> update(entity.Currency currency) async {
    return await (_db.update(_db.currencies)
          ..where((t) => t.id.equals(currency.id!)))
        .write(
      CurrenciesCompanion(
        code: Value(currency.code),
        symbol: Value(currency.symbol),
        name: Value(currency.name),
        isBase: Value(currency.isBase),
      ),
    );
  }

  Future<int> delete(int id) async {
    return await (_db.delete(_db.currencies)..where((t) => t.id.equals(id)))
        .go();
  }

  entity.Currency _currencyFromRow(CurrencyEnt row) {
    return entity.Currency(
      id: row.id,
      code: row.code,
      symbol: row.symbol,
      name: row.name,
      isBase: row.isBase,
    );
  }
}