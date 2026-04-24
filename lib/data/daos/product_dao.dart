import '../../domain/entities/product.dart';
import '../database_helper.dart';

class ProductDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> create(Product product) async {
    final db = await _dbHelper.database;
    return await db.insert('products', product.toMap()..removeWhere((key, value) => value == null));
  }

  Future<List<Product>> getAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('products');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Product.fromMap(result.first);
  }

  Future<Product?> getByCode(String code) async {
    final db = await _dbHelper.database;
    final result = await db.query('products', where: 'code = ?', whereArgs: [code]);
    if (result.isEmpty) return null;
    return Product.fromMap(result.first);
  }

  Future<List<Product>> getByCategory(int idCategory) async {
    final db = await _dbHelper.database;
    final result = await db.query('products', where: 'id_category = ?', whereArgs: [idCategory]);
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getByProvider(int idProvider) async {
    final db = await _dbHelper.database;
    final result = await db.query('products', where: 'id_provider = ?', whereArgs: [idProvider]);
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> update(Product product) async {
    final db = await _dbHelper.database;
    return await db.update(
      'products',
      product.toMap()..removeWhere((key, value) => value == null),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> search(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'products',
      where: 'name LIKE ? OR code LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> updateStock(int id, int newStock) async {
    final db = await _dbHelper.database;
    return await db.update(
      'products',
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}