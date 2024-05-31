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
  late TextEditingController _categoriaController;
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
        title: Text('Editar Quiz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
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
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _preguntaController,
                  decoration: InputDecoration(
                    hintText: 'Introduce tu pregunta...',
                    border: OutlineInputBorder(),
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
                      padding: EdgeInsets.all(90.0),
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      textStyle: TextStyle(fontSize: 27.0),
                    ),
                  ),
                ),
                if (_imagenFile != null) ...[
                  SizedBox(height: 10.0),
                  Image.file(_imagenFile!),
                ],
                SizedBox(height: 10.0),
                Text(
                  'Opcional',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Opciones',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
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
                  ),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _respuestaCorrecta,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                  ),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _dificultad,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return _categorias.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          _categoriaSeleccionada = selection;
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Categoría',
                              border: OutlineInputBorder(),
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
                    onPressed: _guardarCambios,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Guardar Cambios',
                        style: TextStyle(fontSize: 18.0, color: Colors.purple),
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.amber),
                    ),
                  ),
                ),
              ],
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
      ),
      onChanged: (value) {
        setState(() {
          // Update the dropdown menu items whenever an option is changed
          _respuestaCorrecta = null;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, introduce $labelText';
        }
        return null;
      },
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
        title: Text('Listar Quizzes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final quizzes = snapshot.data!.docs
              .map((doc) => Quiz.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return Card(
                margin: EdgeInsets.all(10.0),
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
                          child: Image.network(quiz.imagenURL!,
                              width: 50, height: 50, fit: BoxFit.cover),
                        )
                      : Icon(Icons.image_not_supported),
                  title: Text(quiz.pregunta),
                  subtitle:
                      Text('Respuesta Correcta: ${quiz.respuestaCorrecta}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
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
                        icon: Icon(Icons.delete),
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
    );
  }
}
