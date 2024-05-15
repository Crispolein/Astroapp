import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  String _error = '';

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
        title: const Text('Agregar Noticia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Titulo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Es necesario agregar un Titulo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration:
                    const InputDecoration(labelText: 'Agrege la descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No puede estar vacio este campo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagenURLController,
                decoration: const InputDecoration(labelText: 'Inserte imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No puede estar vacio este campo';
                  }
                  return null;
                },
              ),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
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
                        .where('imagenURL', isEqualTo: nuevoNoticia.imagenURL)
                        .get();
                    if (snapshot.docs.isEmpty) {
                      final DocumentReference document =
                          _noticiaCollection.doc();
                      final nuevoNoticiaConID = Noticia(
                          id: document.id,
                          titulo: nuevoNoticia.titulo,
                          descripcion: nuevoNoticia.descripcion,
                          imagenURL: nuevoNoticia.imagenURL);
                      await document.set({
                        'id': nuevoNoticiaConID.id,
                        'titulo': nuevoNoticiaConID.titulo,
                        'descripcion': nuevoNoticiaConID.descripcion,
                        'imagenURL': nuevoNoticiaConID.imagenURL,
                      });
                      Navigator.pop(context, nuevoNoticiaConID);
                    } else {
                      print("Ya existe esta noticia");
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
