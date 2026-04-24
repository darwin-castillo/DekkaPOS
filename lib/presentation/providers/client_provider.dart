import 'package:flutter/foundation.dart';
import '../../domain/entities/client.dart';

class ClientProvider extends ChangeNotifier {
  Client? _currentClient;
  final List<Client> _clients = [];

  Client? get currentClient => _currentClient;
  List<Client> get clients => List.unmodifiable(_clients);

  void setCurrentClient(Client? client) {
    _currentClient = client;
    notifyListeners();
  }

  void addClient(Client client) {
    _clients.add(client);
    notifyListeners();
  }

  void removeClient(String id) {
    _clients.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}