import 'package:flutter/foundation.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';

class ClientProvider extends ChangeNotifier {
  final ClientRepository _repository;
  Client? _currentClient;
  List<Client> _clients = [];

  ClientProvider(this._repository) {
    loadClients();
  }

  Client? get currentClient => _currentClient;
  List<Client> get clients => List.unmodifiable(_clients);

  void loadClients() {
    _clients = _repository.getAllClients();
    notifyListeners();
  }

  void setCurrentClient(Client? client) {
    _currentClient = client;
    notifyListeners();
  }

  void addClient(Client client) {
    _repository.addClient(client);
    loadClients();
  }

  void updateClient(Client client) {
    _repository.updateClient(client);
    loadClients();
  }

  void deleteClient(String id) {
    _repository.deleteClient(id);
    loadClients();
  }

  Client? findByCedula(String cedula) {
    return _repository.getClientByCedula(cedula);
  }
}