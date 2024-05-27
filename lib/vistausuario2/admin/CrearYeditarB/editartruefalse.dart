import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/categoria/listarcategoria.dart';

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

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
    _preguntaController = TextEditingController(text: widget.question.pregunta);
    _respuestaCorrecta = widget.question.respuestaCorrecta;
    _categoriaSeleccionada = widget.question.categoria;
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
        title: Text('Editar Pregunta de V/F'),
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
                  'Respuesta Correcta',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
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
                    Expanded(
                      child: RadioListTile<bool>(
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
}
