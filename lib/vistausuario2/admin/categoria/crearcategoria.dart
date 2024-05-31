import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:astro_app/models/proyecto_model.dart';

class NuevaCategoria extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _categoriaController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _categoriaCollection =
      FirebaseFirestore.instance.collection('categoria');

  NuevaCategoria({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresar la categoria es obligatorio';
                  }
                  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Ingrese solo letras en la categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final nuevoCategoria = Categoria(
                      id: '',
                      categoria: _categoriaController.text,
                    );

                    final snapshot = await _categoriaCollection
                        .where('categoria', isEqualTo: nuevoCategoria.categoria)
                        .get();

                    if (snapshot.docs.isEmpty) {
                      final DocumentReference document =
                          await _categoriaCollection.add({
                        'categoria': nuevoCategoria.categoria,
                      });
                      final nuevoCategoriaConId = Categoria(
                        id: document.id,
                        categoria: nuevoCategoria.categoria,
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, nuevoCategoriaConId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Esta categoria ya existe, no se agregará un duplicado.'),
                        ),
                      );
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
