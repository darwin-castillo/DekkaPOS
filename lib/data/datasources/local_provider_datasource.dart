import '../../domain/entities/provider.dart';
import '../models/provider_model.dart';

class LocalProviderDataSource {
  static final List<ProviderModel> _providers = [
    const ProviderModel(
      id: 'PROV001',
      nombre: 'Distribuidora Central',
      contacto: 'Juan Pérez',
      telefono: '0212-555-0100',
      email: 'info@distcentral.com',
    ),
    const ProviderModel(
      id: 'PROV002',
      nombre: 'Lácteos Andinos',
      contacto: 'Ana Martínez',
      telefono: '0212-555-0200',
      email: 'contacto@lacteosandinos.com',
    ),
  ];

  List<Provider> getAll() => List.unmodifiable(_providers);

  Provider? getById(String id) {
    try {
      return _providers.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(Provider provider) {
    _providers.add(ProviderModel.fromEntity(provider));
  }

  void update(Provider provider) {
    final index = _providers.indexWhere((p) => p.id == provider.id);
    if (index != -1) {
      _providers[index] = ProviderModel.fromEntity(provider);
    }
  }

  void delete(String id) {
    _providers.removeWhere((p) => p.id == id);
  }
}