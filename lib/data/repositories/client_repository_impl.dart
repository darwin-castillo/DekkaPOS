import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/local_client_datasource.dart';

class ClientRepositoryImpl implements ClientRepository {
  final LocalClientDataSource _dataSource;

  ClientRepositoryImpl(this._dataSource);

  @override
  List<Client> getAllClients() {
    return _dataSource.getAll();
  }

  @override
  Client? getClientById(String id) {
    return _dataSource.getById(id);
  }

  @override
  Client? getClientByCedula(String cedula) {
    return _dataSource.getByCedula(cedula);
  }

  @override
  void addClient(Client client) {
    _dataSource.add(client);
  }

  @override
  void updateClient(Client client) {
    _dataSource.update(client);
  }

  @override
  void deleteClient(String id) {
    _dataSource.delete(id);
  }
}