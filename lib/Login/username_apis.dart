import 'package:astro_app/LoginGoogle.dart';
import 'package:astro_app/vistausuario2/homeb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class GoogleLoginPage extends StatelessWidget {
  const GoogleLoginPage({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final user = await LoginGoogleUtils().signInWithGoogle();
      if (user != null) {
        final userId = user.uid;
        final usernameDoc = await FirebaseFirestore.instance
            .collection('usernames')
            .doc(userId)
            .get();

        if (usernameDoc.exists) {
          // El usuario ya tiene un nombre de usuario asignado, redirigir a la página de inicio
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomebPage()));
        } else {
          // Redirigir a la página para que elija un nombre de usuario
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChooseUsernamePage(userId: userId)));
        }
      } else {
        developer.log("Google sign-in failed, user is null");
      }
    } catch (e) {
      developer.log("Error during Google sign-in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signInWithGoogle(context),
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}

class ChooseUsernamePage extends StatefulWidget {
  final String userId;

  const ChooseUsernamePage({required this.userId, super.key});

  @override
  _ChooseUsernamePageState createState() => _ChooseUsernamePageState();
}

class _ChooseUsernamePageState extends State<ChooseUsernamePage> {
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _error = '';

  Future<void> _saveUsername() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final usernameExists = await FirebaseFirestore.instance
          .collection('usernames')
          .where('username', isEqualTo: username)
          .get();

      if (usernameExists.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('usernames')
            .doc(widget.userId)
            .set({
          'id': widget.userId,
          'username': username,
        });

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomebPage()));
      } else {
        setState(() {
          _error = 'El nombre de usuario ya está en uso';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Elige un nombre de usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
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
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveUsername,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
