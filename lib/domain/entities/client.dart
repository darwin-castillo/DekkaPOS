class Client {
  final int? id;
  final String nombre;
  final String cedula;
  final String telefono;
  final String? direccion;
  final String? email;

  const Client({
    this.id,
    required this.nombre,
    required this.cedula,
    required this.telefono,
    this.direccion,
    this.email,
  });

  Client copyWith({
    int? id,
    String? nombre,
    String? cedula,
    String? telefono,
    String? direccion,
    String? email,
  }) {
    return Client(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cedula': cedula,
      'telefono': telefono,
      'direccion': direccion,
      'email': email,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      cedula: map['cedula'] as String,
      telefono: map['telefono'] as String,
      direccion: map['direccion'] as String?,
      email: map['email'] as String?,
    );
  }
}