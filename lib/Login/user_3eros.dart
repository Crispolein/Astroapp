import 'package:astro_app/models/proyecto_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:astro_app/vistausuario2/homeb.dart';

class SetUsernamePage extends StatefulWidget {
  final String userId;

  const SetUsernamePage({Key? key, required this.userId}) : super(key: key);

  @override
  _SetUsernamePageState createState() => _SetUsernamePageState();
}

class _SetUsernamePageState extends State<SetUsernamePage> {
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _error = '';

  Future<bool> usernameYaExiste(String username) async {
    // Verificar si el username existe en la colección de usuarios
    final resultUsuarios = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('username', isEqualTo: username)
        .get();
    return resultUsuarios.docs.isNotEmpty;
  }

  Future<void> saveUsername(String userId, String username) async {
    // Actualizar el documento del usuario en la colección 'usuarios'
    await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
      'username': username,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Establecer Nombre de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                    return 'El nombre de usuario solo puede contener letras, números y guiones bajos';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool usernameExists =
                        await usernameYaExiste(_usernameController.text);
                    if (usernameExists) {
                      setState(() {
                        _error = 'El nombre de usuario ya existe';
                      });
                    } else {
                      await saveUsername(
                          widget.userId, _usernameController.text);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomebPage()));
                    }
                  }
                },
                child: Text('Guardar'),
              ),
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
