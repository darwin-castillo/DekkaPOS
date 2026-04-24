import '../../domain/entities/category.dart';
import '../database_helper.dart';

class CategoryDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(Category category) async {
    final db = await _dbHelper.database;
    return await db.insert('categories', category.toMap()..removeWhere((key, value) => value == null));
  }

  Future<List<Category>> getAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('categories');
    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<Category?> getById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('categories', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Category.fromMap(result.first);
  }

  Future<int> update(Category category) async {
    final db = await _dbHelper.database;
    return await db.update(
      'categories',
      category.toMap()..removeWhere((key, value) => value == null),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}