import 'dart:io';

import 'package:astro_app/vistausuario2/admin/Noticia/editarnoticia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:astro_app/models/proyecto_model.dart';

class AddNoticia extends StatefulWidget {
  const AddNoticia({Key? key}) : super(key: key);

  @override
  _AddNoticiaState createState() => _AddNoticiaState();
}

class _AddNoticiaState extends State<AddNoticia> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _imagenURLController = TextEditingController();
  File? _imagenFile;
  final ImagePicker _picker = ImagePicker();
  String _error = '';

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
    final storage = firebase_storage.FirebaseStorage.instance;
    final referencia = storage.ref().child('noticia/${DateTime.now()}.jpg');
    await referencia.putFile(imagen);
    return referencia.getDownloadURL();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _noticiaCollection =
      FirebaseFirestore.instance.collection('noticia');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agregar Noticia',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.purple),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: _seleccionarImagen,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: _imagenFile != null
                                ? Image.file(_imagenFile!)
                                : Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.grey[700],
                                  ),
                          )),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _tituloController,
                        decoration: InputDecoration(
                          labelText: 'Título',
                          labelStyle: TextStyle(color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese un título';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          labelStyle: TextStyle(color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese una descripción';
                          }
                          return null;
                        },
                        maxLines: 4,
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_imagenFile != null) {
                      final imagenURL = await _subirImagen(_imagenFile!);
                      _imagenURLController.text = imagenURL;
                    }

                    final nuevoNoticia = Noticia(
                      id: '',
                      titulo: _tituloController.text,
                      descripcion: _descripcionController.text,
                      imagenURL: _imagenURLController.text,
                    );

                    final snapshot = await _noticiaCollection
                        .where('titulo', isEqualTo: nuevoNoticia.titulo)
                        .where('descripcion',
                            isEqualTo: nuevoNoticia.descripcion)
                        .get();

                    if (snapshot.docs.isEmpty) {
                      await _noticiaCollection.add({
                        'titulo': nuevoNoticia.titulo,
                        'descripcion': nuevoNoticia.descripcion,
                        'imagenURL': nuevoNoticia.imagenURL,
                      }).then((DocumentReference document) {
                        final nuevoNoticiaConId = Noticia(
                          id: document.id,
                          titulo: nuevoNoticia.titulo,
                          descripcion: nuevoNoticia.descripcion,
                          imagenURL: nuevoNoticia.imagenURL,
                        );
                        Navigator.pop(context, nuevoNoticiaConId);
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 40.0),
                ),
                child: Text(
                  'Agregar Noticia',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
