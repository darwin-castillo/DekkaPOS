import '../entities/client.dart';

abstract class ClientRepository {
  List<Client> getAllClients();
  Client? getClientById(String id);
  Client? getClientByCedula(String cedula);
  void addClient(Client client);
  void updateClient(Client client);
  void deleteClient(String id);
}