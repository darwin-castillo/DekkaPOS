import '../../domain/entities/client.dart';
import '../models/client_model.dart';

class LocalClientDataSource {
  static final List<ClientModel> _clients = [
    const ClientModel(
      id: 'CLI001',
      nombre: 'Carlos Mendoza',
      cedula: 'V-12345678',
      telefono: '0412-1234567',
    ),
    const ClientModel(
      id: 'CLI002',
      nombre: 'Maria García',
      cedula: 'V-23456789',
      telefono: '0414-2345678',
    ),
    const ClientModel(
      id: 'CLI003',
      nombre: 'Pedro López',
      cedula: 'V-34567890',
      telefono: '0424-3456789',
    ),
  ];

  List<Client> getAll() => List.unmodifiable(_clients);

  Client? getById(String id) {
    try {
      return _clients.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Client? getByCedula(String cedula) {
    try {
      return _clients.firstWhere((c) => c.cedula == cedula);
    } catch (_) {
      return null;
    }
  }

  void add(Client client) {
    _clients.add(ClientModel.fromEntity(client));
  }

  void update(Client client) {
    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index != -1) {
      _clients[index] = ClientModel.fromEntity(client);
    }
  }

  void delete(String id) {
    _clients.removeWhere((c) => c.id == id);
  }
}