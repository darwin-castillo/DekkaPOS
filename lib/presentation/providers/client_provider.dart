import 'package:flutter/foundation.dart';
import '../../domain/entities/client.dart';

class ClientProvider extends ChangeNotifier {
  Client? _currentClient;
  final List<Client> _clients = [];
  bool _isLoading = false;

  Client? get currentClient => _currentClient;
  List<Client> get clients => List.unmodifiable(_clients);
  bool get isLoading => _isLoading;

  void setCurrentClient(Client? client) {
    _currentClient = client;
    notifyListeners();
  }

  void setClients(List<Client> clients) {
    _clients.clear();
    _clients.addAll(clients);
    notifyListeners();
  }

  void addClient(Client client) {
    _clients.add(client);
    notifyListeners();
  }

  void updateClient(Client client) {
    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index >= 0) {
      _clients[index] = client;
      notifyListeners();
    }
  }

  void removeClient(int id) {
    _clients.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}