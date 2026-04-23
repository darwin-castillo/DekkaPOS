class Client {
  final String id;
  final String nombre;
  final String cedula;
  final String telefono;
  final String? direccion;
  final String? email;

  const Client({
    required this.id,
    required this.nombre,
    required this.cedula,
    required this.telefono,
    this.direccion,
    this.email,
  });

  Client copyWith({
    String? id,
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
}