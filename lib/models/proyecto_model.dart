import 'package:cloud_firestore/cloud_firestore.dart';

class Usuarios {
  final String id;
  final String nombre;
  final String apellido;
  final String username;
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
      apellido: map['apellido'],
      username: map['username'],
      correo: map['correo'],
      password: map['password'],
      permisos: map['permisos'],
    );
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
  final String? categoria;

  Quiz({
    required this.id,
    required this.pregunta,
    required this.respuesta,
    required this.respuesta2,
    required this.respuesta3,
    required this.respuesta4,
    required this.respuestaCorrecta,
    required this.dificultad,
    required this.categoria,
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
      'categoria': categoria,
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
      categoria: map['categoria'],
    );
  }
}

class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String imagenURL;
  final String categoria;
  final Timestamp timestamp;

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagenURL,
    required this.categoria,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'imagenURL': imagenURL,
      'categoria': categoria,
      'timestamp': timestamp,
    };
  }

  factory Noticia.fromMap(Map<String, dynamic> map) {
    return Noticia(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      imagenURL: map['imagenURL'],
      categoria: map['categoria'],
      timestamp: map['timestamp'],
    );
  }
}

class FaseLunar {
  final String fecha;
  final String fase;
  final String iluminacion;
  final String edadLuna;
  final String imagen;

  FaseLunar({
    required this.fecha,
    required this.fase,
    required this.iluminacion,
    required this.edadLuna,
    required this.imagen,
  });

  factory FaseLunar.fromJson(Map<String, dynamic> json) {
    return FaseLunar(
      fecha: json['date'] as String,
      fase: json['phase']['name'] as String,
      iluminacion: json['phase']['illumination'] as String,
      edadLuna: json['phase']['age'] as String,
      imagen: json['image_url'] as String,
    );
  }
}

class Categoria {
  final String id;
  final String categoria;

  Categoria({
    required this.id,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': categoria,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      categoria: map['categoria'],
    );
  }
}

class TrueFalseQuestion {
  final String id;
  final String pregunta;
  final bool respuestaCorrecta; // true para verdadero, false para falso
  final String? imagenURL;
  final String categoria;
  final String dificultad; // Nuevo campo para la dificultad

  TrueFalseQuestion({
    required this.id,
    required this.pregunta,
    required this.respuestaCorrecta,
    required this.categoria,
    required this.dificultad, // Asegurarse de que la dificultad es requerida
    this.imagenURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pregunta': pregunta,
      'respuestaCorrecta': respuestaCorrecta,
      'imagenURL': imagenURL,
      'categoria': categoria,
      'dificultad': dificultad, // Incluir dificultad en el mapa
    };
  }

  factory TrueFalseQuestion.fromMap(Map<String, dynamic> map) {
    return TrueFalseQuestion(
      id: map['id'],
      pregunta: map['pregunta'],
      respuestaCorrecta: map['respuestaCorrecta'],
      imagenURL: map['imagenURL'],
      categoria: map['categoria'],
      dificultad: map['dificultad'], // Asignar dificultad desde el mapa
    );
  }
}

class Term {
  final String id;
  final String term;
  final String definition;
  final String categoria;

  Term({
    required this.id,
    required this.term,
    required this.definition,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'term': term,
      'definition': definition,
      'categoria': categoria,
    };
  }

  factory Term.fromMap(Map<String, dynamic> map) {
    return Term(
      id: map['id'],
      term: map['term'],
      definition: map['definition'],
      categoria: map['categoria'],
    );
  }
}

class MemoryCard {
  final String id;
  final String imageUrl;
  final String categoria;

  MemoryCard({
    required this.id,
    required this.imageUrl,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'categoria': categoria,
    };
  }

  factory MemoryCard.fromMap(Map<String, dynamic> map) {
    return MemoryCard(
      id: map['id'],
      imageUrl: map['imageUrl'],
      categoria: map['categoria'],
    );
  }
}

class Ranking {
  final String id;
  final String userId;
  final int score;
  final String game;
  final String level;

  Ranking({
    required this.id,
    required this.userId,
    required this.score,
    required this.game,
    required this.level,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'score': score,
      'game': game,
      'level': level,
    };
  }

  factory Ranking.fromMap(Map<String, dynamic> map) {
    return Ranking(
      id: map['id'],
      userId: map['userId'],
      score: map['score'],
      game: map['game'],
      level: map['level'],
    );
  }
}
