import 'dart:io';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditarNoticiaPage extends StatefulWidget {
  final Noticia noticia;
  const EditarNoticiaPage({Key? key, required this.noticia}) : super(key: key);

  @override
  _EditarNoticiaPageState createState() => _EditarNoticiaPageState();
}

class _EditarNoticiaPageState extends State<EditarNoticiaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _categoriaController;
  File? _imagenFile;
  final ImagePicker _picker = ImagePicker();
  List<String> _categorias = [];

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.noticia.titulo);
    _descripcionController =
        TextEditingController(text: widget.noticia.descripcion);
    _categoriaController =
        TextEditingController(text: widget.noticia.categoria);
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
    final storage = firebase_storage.FirebaseStorage.instance;
    final referencia = storage.ref().child('noticia/${DateTime.now()}.jpg');
    await referencia.putFile(imagen);
    return referencia.getDownloadURL();
  }

  Future<void> _updateNoticia(Noticia noticia) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('noticia')
          .doc(noticia.id)
          .get();
      if (documentSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('noticia')
            .doc(noticia.id)
            .update(noticia.toMap());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Noticia',
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
                                : widget.noticia.imagenURL.isNotEmpty
                                    ? Image.network(widget.noticia.imagenURL)
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
                            return 'Por favor, ingrese un título.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Autocomplete<String>(
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
                          _categoriaController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          fieldTextEditingController.text =
                              _categoriaController.text;
                          return TextFormField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Categoría',
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
                                return 'Por favor, ingrese una categoría.';
                              } else if (!_categorias.contains(value)) {
                                return 'La categoría ingresada no existe';
                              }
                              return null;
                            },
                          );
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
                            return 'Por favor, ingrese una descripción.';
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
                    String? imagenURL = widget.noticia.imagenURL;
                    if (_imagenFile != null) {
                      imagenURL = await _subirImagen(_imagenFile!);
                    }

                    final nuevaNoticia = Noticia(
                      id: widget.noticia.id,
                      titulo: _tituloController.text,
                      categoria: _categoriaController.text,
                      descripcion: _descripcionController.text,
                      imagenURL: imagenURL,
                      timestamp: widget.noticia.timestamp,
                    );
                    await _updateNoticia(nuevaNoticia);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                ),
                child: Text(
                  'Editar Noticia',
                  style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
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
