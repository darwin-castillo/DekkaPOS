import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('CategoryEnt')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
}

@DataClassName('ProviderEnt')
class Providers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
}

@DataClassName('ProductEnt')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get code => text().unique()();
  IntColumn get idCategory => integer().nullable().references(Categories, #id)();
  IntColumn get idProvider => integer().nullable().references(Providers, #id)();
  RealColumn get cost => real().withDefault(const Constant(0))();
  RealColumn get price => real()();
  RealColumn get stock => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  TextColumn get unit => text().withDefault(const Constant('und'))();
}

@DriftDatabase(tables: [Categories, Providers, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'dekkapos.db');
  }

  static AppDatabase? _instance;

  static AppDatabase get instance {
    _instance ??= AppDatabase();
    return _instance!;
  }
}