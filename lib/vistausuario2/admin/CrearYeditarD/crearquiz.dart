import 'package:astro_app/vistausuario2/admin/categoria/listarcategoria.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CrearImagenesPage extends StatefulWidget {
  @override
  _CrearImagenesPageState createState() => _CrearImagenesPageState();
}

class _CrearImagenesPageState extends State<CrearImagenesPage> {
  final List<File?> _imageFiles = [];
  String _categoriaSeleccionada = '';
  List<String> _categorias = [];

  @override
  void initState() {
    super.initState();
    _addImageSlot();
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

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFiles[index] = File(pickedFile.path);
      });
    }
  }

  void _addImageSlot() {
    setState(() {
      _imageFiles.add(null);
    });
  }

  void _removeImageSlot(int index) {
    if (_imageFiles.length > 1) {
      setState(() {
        _imageFiles.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debe haber al menos una imagen')));
    }
  }

  Future<void> _saveImages() async {
    if (_imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, añade al menos una imagen')));
      return;
    }

    if (!_categorias.contains(_categoriaSeleccionada)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, selecciona una categoría válida')));
      return;
    }

    List<Map<String, String>> imageEntries = [];
    for (int i = 0; i < _imageFiles.length; i++) {
      if (_imageFiles[i] == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Por favor, selecciona todas las imágenes antes de guardar')));
        return;
      }

      // Subir la imagen a Firebase Storage
      String imageUrl = await _uploadFile(_imageFiles[i]!);

      imageEntries.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
        'imageUrl': imageUrl,
        'categoria': _categoriaSeleccionada,
      });
    }

    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var entry in imageEntries) {
        final docRef = FirebaseFirestore.instance
            .collection('memoryImages')
            .doc(entry['id']);
        batch.set(docRef, entry);
      }
      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imágenes guardadas con éxito')));
      Navigator.pop(context); // Redirige a la página anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar las imágenes: $e')));
    }
  }

  Future<String> _uploadFile(File file) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('memory_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Imágenes de Memoria'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Imágenes',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Column(
                children: List.generate(_imageFiles.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        if (_imageFiles[index] != null)
                          Image.file(
                            _imageFiles[index]!,
                            height: 100,
                            width: 100,
                          ),
                        if (_imageFiles[index] == null)
                          Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: Icon(Icons.image, size: 50),
                          ),
                        SizedBox(width: 10.0),
                        IconButton(
                          icon: Icon(Icons.image),
                          color: Colors.blue,
                          onPressed: () {
                            _pickImage(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.red,
                          onPressed: () {
                            _removeImageSlot(index);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 10.0),
              Text(
                'Categoría',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
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
                        setState(() {
                          _categoriaSeleccionada = selection;
                        });
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
              SizedBox(height: 10.0),
              Center(
                child: ElevatedButton(
                  onPressed: _addImageSlot,
                  child: Text('Agregar Imagen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _saveImages,
                    child: Text(
                      'Guardar Imágenes',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
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
    );
  }
}
