import 'package:drift/drift.dart';
import '../../domain/entities/provider.dart' as entity;
import '../app_database.dart';

class ProviderDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(entity.Provider provider) async {
    return await _db.into(_db.providers).insert(
      ProvidersCompanion.insert(
        name: provider.name,
        description: Value(provider.description),
        phone: Value(provider.phone),
        address: Value(provider.address),
      ),
    );
  }

  Future<List<entity.Provider>> getAll() async {
    final results = await _db.select(_db.providers).get();
    return results.map(_providerFromRow).toList();
  }

  Future<entity.Provider?> getById(int id) async {
    final result = await (_db.select(_db.providers)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null ? _providerFromRow(result) : null;
  }

  Future<int> update(entity.Provider provider) async {
    return await (_db.update(_db.providers)
          ..where((t) => t.id.equals(provider.id!)))
        .write(
      ProvidersCompanion(
        name: Value(provider.name),
        description: Value(provider.description),
        phone: Value(provider.phone),
        address: Value(provider.address),
      ),
    );
  }

  Future<int> delete(int id) async {
    return await (_db.delete(_db.providers)..where((t) => t.id.equals(id)))
        .go();
  }

  entity.Provider _providerFromRow(ProviderEnt row) {
    return entity.Provider(
      id: row.id,
      name: row.name,
      description: row.description,
      phone: row.phone,
      address: row.address,
    );
  }
}