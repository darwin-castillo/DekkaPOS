import '../../domain/entities/provider.dart';
import '../../domain/repositories/provider_repository.dart';
import '../datasources/local_provider_datasource.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  final LocalProviderDataSource _dataSource;

  ProviderRepositoryImpl(this._dataSource);

  @override
  List<Provider> getAllProviders() {
    return _dataSource.getAll();
  }

  @override
  Provider? getProviderById(String id) {
    return _dataSource.getById(id);
  }

  @override
  void addProvider(Provider provider) {
    _dataSource.add(provider);
  }

  @override
  void updateProvider(Provider provider) {
    _dataSource.update(provider);
  }

  @override
  void deleteProvider(String id) {
    _dataSource.delete(id);
  }
}