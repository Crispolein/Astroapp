class Usuarios {
  final String id;
  final String nombre;
  final String apellido;
  final dynamic username;
  final String? correo;
  final String? password;
  final int? permisos;

  Usuarios({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.username,
    required this.correo,
    required this.password,
    this.permisos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'username': username,
      'correo': correo,
      'password': password,
      'permisos': permisos,
    };
  }

  factory Usuarios.fromMap(Map<String, dynamic> map) {
    return Usuarios(
        id: map['id'],
        nombre: map['nombre'],
        apellido: 'apellido',
        username: map['username'],
        password: map['password'],
        correo: map['correo'],
        permisos: map['permisos']);
  }
}

class Quiz {
  final String id;
  final String pregunta;
  final String respuesta;
  final String respuesta2;
  final String respuesta3;
  final String respuesta4;
  final String respuestaCorrecta;
  final String? imagenURL;
  final String? dificultad;

  Quiz({
    required this.id,
    required this.pregunta,
    required this.respuesta,
    required this.respuesta2,
    required this.respuesta3,
    required this.respuesta4,
    required this.respuestaCorrecta,
    required this.dificultad,
    this.imagenURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pregunta': pregunta,
      'respuesta': respuesta,
      'respuesta2': respuesta2,
      'respuesta3': respuesta3,
      'respuesta4': respuesta4,
      'dificultad': dificultad,
      'respuestaCorrecta': respuestaCorrecta,
      'imagenURL': imagenURL,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'],
      pregunta: map['pregunta'],
      respuesta: map['respuesta'],
      respuesta2: map['respuesta2'],
      respuesta3: map['respuesta3'],
      respuesta4: map['respuesta4'],
      respuestaCorrecta: map['respuestaCorrecta'],
      dificultad: map['dificultad'],
      imagenURL: map['imagenURL'],
    );
  }
}

class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String imagenURL;

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagenURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'imagen': imagenURL,
    };
  }

  factory Noticia.fromMap(Map<String, dynamic> map) {
    return Noticia(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      imagenURL: map['imagen'],
    );
  }
}
