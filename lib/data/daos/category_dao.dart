import 'package:drift/drift.dart';
import '../../domain/entities/category.dart' as entity;
import '../app_database.dart';

class CategoryDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(entity.Category category) async {
    return await _db.into(_db.categories).insert(
      CategoriesCompanion.insert(
        name: category.name,
        description: Value(category.description),
      ),
    );
  }

  Future<List<entity.Category>> getAll() async {
    final results = await _db.select(_db.categories).get();
    return results.map(_categoryFromRow).toList();
  }

  Future<entity.Category?> getById(int id) async {
    final result = await (_db.select(_db.categories)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null ? _categoryFromRow(result) : null;
  }

  Future<int> update(entity.Category category) async {
    return await (_db.update(_db.categories)
          ..where((t) => t.id.equals(category.id!)))
        .write(
      CategoriesCompanion(
        name: Value(category.name),
        description: Value(category.description),
      ),
    );
  }

  Future<int> delete(int id) async {
    return await (_db.delete(_db.categories)..where((t) => t.id.equals(id)))
        .go();
  }

  entity.Category _categoryFromRow(CategoryEnt row) {
    return entity.Category(
      id: row.id,
      name: row.name,
      description: row.description,
    );
  }
}