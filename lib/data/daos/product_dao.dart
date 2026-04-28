import 'package:drift/drift.dart';
import '../../domain/entities/product.dart' as entity;
import '../app_database.dart';

class ProductDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(entity.Product product) async {
    return await _db
        .into(_db.products)
        .insert(
          ProductsCompanion.insert(
            name: product.name,
            code: product.code,
            price: product.price,
            description: Value(product.description),
            idCategory: Value(product.idCategory),
            idProvider: Value(product.idProvider),
            cost: Value(product.cost),
            stock: Value(product.stock),
            discount: Value(product.discount),
            unit: Value(product.unit.code),
          ),
        );
  }

  Future<List<entity.Product>> getAll() async {
    final results = await _db.select(_db.products).get();
    return results.map(_productFromRow).toList();
  }

  Future<entity.Product?> getById(int id) async {
    final result = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return result != null ? _productFromRow(result) : null;
  }

  Future<entity.Product?> getByCode(String code) async {
    final result = await (_db.select(
      _db.products,
    )..where((t) => t.code.equals(code))).getSingleOrNull();
    return result != null ? _productFromRow(result) : null;
  }

  Future<List<entity.Product>> getByCategory(int idCategory) async {
    final results = await (_db.select(
      _db.products,
    )..where((t) => t.idCategory.equals(idCategory))).get();
    return results.map(_productFromRow).toList();
  }

  Future<List<entity.Product>> getByProvider(int idProvider) async {
    final results = await (_db.select(
      _db.products,
    )..where((t) => t.idProvider.equals(idProvider))).get();
    return results.map(_productFromRow).toList();
  }

  Future<int> update(entity.Product product) async {
    return await (_db.update(
      _db.products,
    )..where((t) => t.id.equals(product.id!))).write(
      ProductsCompanion(
        name: Value(product.name),
        description: Value(product.description),
        code: Value(product.code),
        idCategory: Value(product.idCategory),
        idProvider: Value(product.idProvider),
        cost: Value(product.cost),
        price: Value(product.price),
        stock: Value(product.stock),
        discount: Value(product.discount),
        unit: Value(product.unit.code),
      ),
    );
  }

  Future<int> delete(int id) async {
    return await (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();
  }

  Future<List<entity.Product>> search(String query) async {
    final results = await (_db.select(
      _db.products,
    )..where((t) => t.name.like('%$query%') | t.code.like('%$query%'))).get();
    return results.map(_productFromRow).toList();
  }

  Future<int> updateStock(int id, double newStock) async {
    return await (_db.update(_db.products)..where((t) => t.id.equals(id)))
        .write(ProductsCompanion(stock: Value(newStock)));
  }

  entity.Product _productFromRow(ProductEnt row) {
    return entity.Product(
      id: row.id,
      name: row.name,
      description: row.description,
      code: row.code,
      idCategory: row.idCategory,
      idProvider: row.idProvider,
      cost: row.cost,
      price: row.price,
      stock: row.stock,
      discount: row.discount,
      unit: entity.SaleUnit.fromCode(row.unit),
    );
  }
}
