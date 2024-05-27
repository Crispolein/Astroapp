import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:astro_app/models/proyecto_model.dart';

class EditarCategoria extends StatelessWidget {
  final Categoria categoria;
  final _formKey = GlobalKey<FormState>();
  final _categoriaController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _categoriaCollection =
      FirebaseFirestore.instance.collection('categoria');

  EditarCategoria({required this.categoria, super.key}) {
    _categoriaController.text = categoria.categoria;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Categoria'),
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
                    await _categoriaCollection.doc(categoria.id).update({
                      'categoria': _categoriaController.text,
                    });
                    Navigator.pop(context);
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
