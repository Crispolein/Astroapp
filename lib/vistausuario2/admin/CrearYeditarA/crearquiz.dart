import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/admin/categoria/listarcategoria.dart';

class CrearQuizPage extends StatefulWidget {
  @override
  _CrearQuizPageState createState() => _CrearQuizPageState();
}

class _CrearQuizPageState extends State<CrearQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _preguntaController = TextEditingController();
  final _respuesta1Controller = TextEditingController();
  final _respuesta2Controller = TextEditingController();
  final _respuesta3Controller = TextEditingController();
  final _respuesta4Controller = TextEditingController();
  final _categoriaController = TextEditingController();
  String? _respuestaCorrecta;
  String? _dificultad;
  File? _imagenFile;
  final ImagePicker _picker = ImagePicker();
  String _categoriaSeleccionada = '';
  List<String> _categorias = [];

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categoria').get();
    setState(() {
      _categorias =
          snapshot.docs.map((doc) => doc['categoria'] as String).toList();
    });
  }

  Future<void> _seleccionarImagen() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagenFile = File(pickedFile.path);
        });
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> _subirImagen(File imagen) async {
    final storage = FirebaseStorage.instance;
    final referencia = storage.ref().child('quiz/${DateTime.now()}.jpg');
    await referencia.putFile(imagen);
    return referencia.getDownloadURL();
  }

  Future<void> _guardarQuiz() async {
    if (_formKey.currentState!.validate()) {
      String? imagenURL;
      if (_imagenFile != null) {
        imagenURL = await _subirImagen(_imagenFile!);
      }

      final nuevoQuiz = Quiz(
        id: FirebaseFirestore.instance.collection('quizzes').doc().id,
        pregunta: _preguntaController.text,
        respuesta: _respuesta1Controller.text,
        respuesta2: _respuesta2Controller.text,
        respuesta3: _respuesta3Controller.text,
        respuesta4: _respuesta4Controller.text,
        respuestaCorrecta: _respuestaCorrecta!,
        categoria: _categoriaController.text,
        dificultad: _dificultad!,
        imagenURL: imagenURL,
      );

      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(nuevoQuiz.id)
          .set(nuevoQuiz.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Quiz'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pregunta',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _preguntaController,
                      decoration: InputDecoration(
                        hintText: 'Introduce tu pregunta...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, introduce una pregunta';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Agregar Imagen',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _seleccionarImagen,
                        icon: Icon(
                          Icons.image,
                          size: 70.0,
                        ),
                        label: Text('Seleccionar Imagen'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          textStyle: TextStyle(fontSize: 23.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    if (_imagenFile != null) ...[
                      SizedBox(height: 10.0),
                      Image.file(_imagenFile!),
                    ],
                    SizedBox(height: 20.0),
                    Text(
                      'Opcional',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Opciones',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          _buildOptionField('Opción 1', _respuesta1Controller),
                          _buildOptionField('Opción 2', _respuesta2Controller),
                          _buildOptionField('Opción 3', _respuesta3Controller),
                          _buildOptionField('Opción 4', _respuesta4Controller),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Opción Correcta',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      value: _respuestaCorrecta,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        _respuesta1Controller.text,
                        _respuesta2Controller.text,
                        _respuesta3Controller.text,
                        _respuesta4Controller.text,
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _respuestaCorrecta = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecciona la opción correcta';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Dificultad',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      value: _dificultad,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ['Fácil', 'Medio', 'Difícil'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _dificultad = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecciona una dificultad';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Autocomplete<String>(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return _categorias.where((String option) {
                                return option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (String selection) {
                              _categoriaSeleccionada = selection;
                            },
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController
                                    fieldTextEditingController,
                                FocusNode fieldFocusNode,
                                VoidCallback onFieldSubmitted) {
                              return TextFormField(
                                controller: fieldTextEditingController,
                                focusNode: fieldFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Categoría',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, selecciona una categoría';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListaCategorias(),
                              ),
                            ).then((value) {
                              _cargarCategorias();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _guardarQuiz,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Guardar',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          textStyle: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _respuestaCorrecta = null;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce $labelText';
        }
        return null;
      },
      style: TextStyle(fontSize: 16.0),
    );
  }
}
