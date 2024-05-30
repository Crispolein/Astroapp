import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditarImagenesPage extends StatefulWidget {
  final String categoria;

  EditarImagenesPage({required this.categoria});

  @override
  _EditarImagenesPageState createState() => _EditarImagenesPageState();
}

class _EditarImagenesPageState extends State<EditarImagenesPage> {
  List<Map<String, dynamic>> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('memoryImages')
        .where('categoria', isEqualTo: widget.categoria)
        .get();
    setState(() {
      _images = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'imageUrl': doc['imageUrl'],
              })
          .toList();
    });
  }

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String imageUrl = await _uploadFile(File(pickedFile.path));
      setState(() {
        _images[index]['imageUrl'] = imageUrl;
      });
      await FirebaseFirestore.instance
          .collection('memoryImages')
          .doc(_images[index]['id'])
          .update({'imageUrl': imageUrl});
    }
  }

  Future<void> _deleteImage(String id, int index) async {
    await FirebaseFirestore.instance
        .collection('memoryImages')
        .doc(id)
        .delete();
    setState(() {
      _images.removeAt(index);
    });
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
        title: Text('Categoría: ${widget.categoria}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_images.isNotEmpty)
                Column(
                  children: _images.map((image) {
                    int index = _images.indexOf(image);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          if (image['imageUrl'] != null)
                            Image.network(
                              image['imageUrl'],
                              height: 100,
                              width: 100,
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
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _deleteImage(image['id'], index);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              else
                Center(
                  child: Text(
                    'No hay imágenes para esta categoría',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
