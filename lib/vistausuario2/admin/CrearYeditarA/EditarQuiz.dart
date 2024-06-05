import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/admin/categoria/listarcategoria.dart';

class EditarQuizPage extends StatefulWidget {
  final Quiz quiz;

  const EditarQuizPage({Key? key, required this.quiz}) : super(key: key);

  @override
  _EditarQuizPageState createState() => _EditarQuizPageState();
}

class _EditarQuizPageState extends State<EditarQuizPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _preguntaController;
  late TextEditingController _respuesta1Controller;
  late TextEditingController _respuesta2Controller;
  late TextEditingController _respuesta3Controller;
  late TextEditingController _respuesta4Controller;
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
    _preguntaController = TextEditingController(text: widget.quiz.pregunta);
    _respuesta1Controller = TextEditingController(text: widget.quiz.respuesta);
    _respuesta2Controller = TextEditingController(text: widget.quiz.respuesta2);
    _respuesta3Controller = TextEditingController(text: widget.quiz.respuesta3);
    _respuesta4Controller = TextEditingController(text: widget.quiz.respuesta4);
    _respuestaCorrecta = widget.quiz.respuestaCorrecta;
    _dificultad = widget.quiz.dificultad;
    _categoriaSeleccionada = widget.quiz.categoria ?? '';
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

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      String? imagenURL = widget.quiz.imagenURL;
      if (_imagenFile != null) {
        imagenURL = await _subirImagen(_imagenFile!);
      }

      final updatedQuiz = Quiz(
        id: widget.quiz.id,
        pregunta: _preguntaController.text,
        respuesta: _respuesta1Controller.text,
        respuesta2: _respuesta2Controller.text,
        respuesta3: _respuesta3Controller.text,
        respuesta4: _respuesta4Controller.text,
        respuestaCorrecta: _respuestaCorrecta!,
        categoria: _categoriaSeleccionada,
        dificultad: _dificultad!,
        imagenURL: imagenURL,
      );

      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(updatedQuiz.id)
          .update(updatedQuiz.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Quiz'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pregunta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
                    const Text(
                      'Agregar Imagen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _seleccionarImagen,
                        icon: const Icon(
                          Icons.image,
                          size: 80,
                        ),
                        label: const Text('Seleccionar Imagen'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 23),
                        ),
                      ),
                    ),
                    if (_imagenFile != null) ...[
                      const SizedBox(height: 10),
                      Image.file(_imagenFile!),
                    ],
                    const SizedBox(height: 20),
                    const Text(
                      'Opcional',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Opciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
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
                    const SizedBox(height: 20),
                    const Text(
                      'Opción Correcta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
                    const Text(
                      'Dificultad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
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
                          icon: const Icon(Icons.add),
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _guardarCambios,
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Guardar Cambios',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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
      ),
    );
  }
}

class ListarQuizPage extends StatefulWidget {
  @override
  _ListarQuizPageState createState() => _ListarQuizPageState();
}

class _ListarQuizPageState extends State<ListarQuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Quizzes'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0), // Espacio adicional
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final quizzes = snapshot.data!.docs
                .map((doc) => Quiz.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: quiz.imagenURL != null
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  content: Image.network(quiz.imagenURL!),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                quiz.imagenURL!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(
                      quiz.pregunta,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Respuesta Correcta: ${quiz.respuestaCorrecta}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.teal),
                          iconSize: 30.0, // Tamaño del icono de editar
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditarQuizPage(quiz: quiz)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          iconSize: 30.0, // Tamaño del icono de eliminar
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('quizzes')
                                .doc(quiz.id)
                                .delete();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
