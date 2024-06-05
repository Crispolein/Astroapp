import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/admin/categoria/listarcategoria.dart';

class EditarTrueFalsePage extends StatefulWidget {
  final TrueFalseQuestion question;

  const EditarTrueFalsePage({required this.question})
      : super(key: const Key(''));

  @override
  // ignore: library_private_types_in_public_api
  _EditarTrueFalsePageState createState() => _EditarTrueFalsePageState();
}

class _EditarTrueFalsePageState extends State<EditarTrueFalsePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _preguntaController;
  bool _respuestaCorrecta = true;
  File? _imagenFile;
  final ImagePicker _picker = ImagePicker();
  String _categoriaSeleccionada = '';
  List<String> _categorias = [];
  String _dificultadSeleccionada = ''; // Variable para la dificultad
  final List<String> _dificultades = [
    'Facil',
    'Medio',
    'Difícil'
  ]; // Lista de dificultades

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
    _preguntaController = TextEditingController(text: widget.question.pregunta);
    _respuestaCorrecta = widget.question.respuestaCorrecta;
    _categoriaSeleccionada = widget.question.categoria;
    _dificultadSeleccionada =
        widget.question.dificultad; // Inicializar la dificultad
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
    final referencia = storage.ref().child('truefalse/${DateTime.now()}.jpg');
    await referencia.putFile(imagen);
    return referencia.getDownloadURL();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      String? imagenURL = widget.question.imagenURL;
      if (_imagenFile != null) {
        imagenURL = await _subirImagen(_imagenFile!);
      }

      final updatedQuestion = TrueFalseQuestion(
        id: widget.question.id,
        pregunta: _preguntaController.text,
        respuestaCorrecta: _respuestaCorrecta,
        categoria: _categoriaSeleccionada,
        dificultad: _dificultadSeleccionada,
        imagenURL: imagenURL,
      );

      await FirebaseFirestore.instance
          .collection('truefalse')
          .doc(updatedQuestion.id)
          .update(updatedQuestion.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pregunta de V/F'),
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
                    const SizedBox(height: 10.0),
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
                    const SizedBox(height: 20.0),
                    const Text(
                      'Agregar Imagen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _seleccionarImagen,
                        icon: const Icon(
                          Icons.image,
                          size: 70.0,
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
                      const SizedBox(height: 10.0),
                      Image.file(_imagenFile!),
                    ],
                    const SizedBox(height: 20.0),
                    const Text(
                      'Respuesta Correcta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: -10.0),
                            title: const Text('Verdadero'),
                            value: true,
                            groupValue: _respuestaCorrecta,
                            onChanged: (bool? value) {
                              setState(() {
                                _respuestaCorrecta = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0), // Espaciado adicional
                        Expanded(
                          child: RadioListTile<bool>(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: -10.0),
                            title: const Text('Falso'),
                            value: false,
                            groupValue: _respuestaCorrecta,
                            onChanged: (bool? value) {
                              setState(() {
                                _respuestaCorrecta = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Dificultad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      value: _dificultadSeleccionada,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _dificultades.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _dificultadSeleccionada = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecciona una dificultad';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
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
                          icon: const Icon(Icons.add, color: Colors.teal),
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
                    const SizedBox(height: 20.0),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _guardarCambios,
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'Guardar Cambios',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
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
}
