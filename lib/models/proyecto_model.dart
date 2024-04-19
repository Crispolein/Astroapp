class Usuarios {
  final String id;
  final String nombre;
  final String apellido;
  final dynamic username;
  final String? correo;
  final String? password;

  Usuarios({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.username,
    required this.correo,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'username': username,
      'correo': correo,
      'password': password,
    };
  }

  factory Usuarios.fromMap(Map<String, dynamic> map) {
    return Usuarios(
        id: map['id'],
        nombre: map['nombre'],
        apellido: 'apellido',
        username: map['username'],
        password: map['password'],
        correo: map['correo']);
  }
}
