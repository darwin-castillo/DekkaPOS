import '../../domain/entities/provider.dart';
import '../database_helper.dart';

class ProviderDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(Provider provider) async {
    final db = await _dbHelper.database;
    return await db.insert('providers', provider.toMap()..removeWhere((key, value) => value == null));
  }

  Future<List<Provider>> getAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('providers');
    return result.map((map) => Provider.fromMap(map)).toList();
  }

  Future<Provider?> getById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('providers', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Provider.fromMap(result.first);
  }

  Future<int> update(Provider provider) async {
    final db = await _dbHelper.database;
    return await db.update(
      'providers',
      provider.toMap()..removeWhere((key, value) => value == null),
      where: 'id = ?',
      whereArgs: [provider.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('providers', where: 'id = ?', whereArgs: [id]);
  }
}