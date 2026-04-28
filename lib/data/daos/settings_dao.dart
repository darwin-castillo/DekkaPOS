import 'package:drift/drift.dart';
import '../app_database.dart';

class SettingsDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<String?> getValue(String key) async {
    final result = await (_db.select(_db.settings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return result?.value;
  }

  Future<void> setValue(String key, String value) async {
    final existing = await getValue(key);
    if (existing != null) {
      await (_db.update(_db.settings)
            ..where((t) => t.key.equals(key)))
          .write(
        SettingsCompanion(value: Value(value)),
      );
    } else {
      await _db.into(_db.settings).insert(
        SettingsCompanion.insert(key: key, value: value),
      );
    }
  }

  Future<Map<String, String>> getAll() async {
    final results = await _db.select(_db.settings).get();
    return {for (var r in results) r.key: r.value};
  }
}