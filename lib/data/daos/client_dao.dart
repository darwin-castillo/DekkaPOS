import 'package:drift/drift.dart';
import '../../domain/entities/client.dart';
import '../app_database.dart';

class ClientDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(Client client) async {
    return await _db.into(_db.clients).insert(
      ClientsCompanion.insert(
        nombre: client.nombre,
        cedula: client.cedula,
        telefono: client.telefono,
        direccion: Value(client.direccion),
        email: Value(client.email),
      ),
    );
  }

  Future<List<Client>> getAll() async {
    final results = await _db.select(_db.clients).get();
    return results.map(_clientFromRow).toList();
  }

  Future<Client?> getById(int id) async {
    final result = await (_db.select(_db.clients)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null ? _clientFromRow(result) : null;
  }

  Future<int> update(Client client) async {
    return await (_db.update(_db.clients)
          ..where((t) => t.id.equals(client.id!)))
        .write(
      ClientsCompanion(
        nombre: Value(client.nombre),
        cedula: Value(client.cedula),
        telefono: Value(client.telefono),
        direccion: Value(client.direccion),
        email: Value(client.email),
      ),
    );
  }

  Future<int> delete(int id) async {
    return await (_db.delete(_db.clients)..where((t) => t.id.equals(id)))
        .go();
  }

  Client _clientFromRow(ClientEnt row) {
    return Client(
      id: row.id,
      nombre: row.nombre,
      cedula: row.cedula,
      telefono: row.telefono,
      direccion: row.direccion,
      email: row.email,
    );
  }
}