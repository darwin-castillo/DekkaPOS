import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDB('dekkapos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE providers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        phone TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        code TEXT NOT NULL UNIQUE,
        id_category INTEGER,
        id_provider INTEGER,
        cost REAL NOT NULL DEFAULT 0,
        price REAL NOT NULL DEFAULT 0,
        stock REAL NOT NULL DEFAULT 0,
        discount REAL NOT NULL DEFAULT 0,
        unit TEXT NOT NULL DEFAULT 'und',
        FOREIGN KEY (id_category) REFERENCES categories (id),
        FOREIGN KEY (id_provider) REFERENCES providers (id)
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}