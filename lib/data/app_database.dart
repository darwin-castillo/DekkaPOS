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

@DataClassName('CurrencyEnt')
class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get symbol => text()();
  TextColumn get name => text()();
  BoolColumn get isBase => boolean().withDefault(const Constant(false))();
}

@DataClassName('ExchangeRateEnt')
class ExchangeRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('fromCurrency')
  IntColumn get fromId => integer().references(Currencies, #id)();
  @ReferenceName('toCurrency')
  IntColumn get toId => integer().references(Currencies, #id)();
  RealColumn get value => real()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('InvoiceEnt')
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get numero => text().unique()();
  DateTimeColumn get fecha => dateTime()();
  IntColumn get clienteId => integer().nullable()();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get tax => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  IntColumn get baseCurrencyId => integer()();
  TextColumn get metodoPago => text().withDefault(const Constant('efectivo'))();
  TextColumn get status => text().withDefault(const Constant('pendiente'))();
  TextColumn get totalSnapshot => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('InvoiceItemEnt')
class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id)();
  IntColumn get productoId => integer().references(Products, #id)();
  RealColumn get cantidad => real().withDefault(const Constant(1))();
  RealColumn get precioUnitario => real()();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  TextColumn get totalSnapshot => text().nullable()();
}

@DataClassName('SettingsEnt')
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
}

@DataClassName('ClientEnt')
class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get cedula => text()();
  TextColumn get telefono => text()();
  TextColumn get direccion => text().nullable()();
  TextColumn get email => text().nullable()();
}

@DriftDatabase(tables: [Categories, Providers, Products, Currencies, ExchangeRates, Invoices, InvoiceItems, Settings, Clients])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await into(currencies).insert(CurrenciesCompanion.insert(
          code: 'USD',
          symbol: r'$',
          name: 'Dólar',
          isBase: const Value(true),
        ));
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations will go here
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'dekkapos.db');
  }

  static AppDatabase? _instance;

  static AppDatabase get instance {
    _instance ??= AppDatabase();
    return _instance!;
  }
}