import '../entities/provider.dart';

abstract class ProviderRepository {
  List<Provider> getAllProviders();
  Provider? getProviderById(String id);
  void addProvider(Provider provider);
  void updateProvider(Provider provider);
  void deleteProvider(String id);
}