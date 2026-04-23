import '../../domain/entities/provider.dart';

class ProviderModel extends Provider {
  const ProviderModel({
    required super.id,
    required super.nombre,
    required super.contacto,
    required super.telefono,
    required super.email,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      contacto: json['contacto'] as String,
      telefono: json['telefono'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'contacto': contacto,
      'telefono': telefono,
      'email': email,
    };
  }

  factory ProviderModel.fromEntity(Provider provider) {
    return ProviderModel(
      id: provider.id,
      nombre: provider.nombre,
      contacto: provider.contacto,
      telefono: provider.telefono,
      email: provider.email,
    );
  }
}