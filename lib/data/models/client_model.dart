import '../../domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.nombre,
    required super.cedula,
    required super.telefono,
    super.direccion,
    super.email,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      cedula: json['cedula'] as String,
      telefono: json['telefono'] as String,
      direccion: json['direccion'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'cedula': cedula,
      'telefono': telefono,
      'direccion': direccion,
      'email': email,
    };
  }

  factory ClientModel.fromEntity(Client client) {
    return ClientModel(
      id: client.id,
      nombre: client.nombre,
      cedula: client.cedula,
      telefono: client.telefono,
      direccion: client.direccion,
      email: client.email,
    );
  }
}