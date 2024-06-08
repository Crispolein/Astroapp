import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPerfil extends StatefulWidget {
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _nombreUsuarioController = TextEditingController();
  final _correoController = TextEditingController();
  File? _image;
  String _usernameError = '';
  bool _isUsernameValid = true; // Inicializamos en true
  String? _originalUsername;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _correoController.text = user.email ?? '';
      });

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _nombreController.text = userDoc['nombre'] ?? '';
          _apellidoController.text = userDoc['apellido'] ?? '';
          _nombreUsuarioController.text = userDoc['username'] ?? '';
          _originalUsername = userDoc['username'];
        });
      }
    }
  }

  void _guardarCambios() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('usuarios').doc(user.uid).update({
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'username': _nombreUsuarioController.text,
      }).then((_) {
        Navigator.pop(context, 'Los cambios se guardaron correctamente');
      });
    }
  }

  Future<void> _verificarNombreUsuario() async {
    if (_nombreUsuarioController.text == _originalUsername) {
      // Si el nombre de usuario es el mismo que el original, es válido
      setState(() {
        _usernameError = '';
        _isUsernameValid = true;
      });
    } else {
      final result = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('username', isEqualTo: _nombreUsuarioController.text)
          .get();

      setState(() {
        if (result.docs.isNotEmpty) {
          _usernameError = 'El nombre de usuario ya existe';
          _isUsernameValid = false;
        } else {
          _usernameError = 'El nombre de usuario está disponible';
          _isUsernameValid = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Color(0xFF121212) : Colors.white;
    final appBarColor = isDarkTheme ? Color(0xFF1F1F1F) : Colors.amber;
    final textColor = isDarkTheme ? Colors.white : Colors.black;
    final buttonColor = isDarkTheme ? Colors.purple : Colors.amber;
    final containerColor = isDarkTheme ? Color(0xFF2C2C2E) : Color(0xFFFFFFFF);
    final shadowColor =
        isDarkTheme ? Color.fromARGB(177, 255, 22, 22) : Colors.black26;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil', style: TextStyle(color: textColor)),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 10.0,
                    spreadRadius: 1.9,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 10.0,
                    spreadRadius: 1.9,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 10.0,
                    spreadRadius: 1.9,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _nombreUsuarioController,
                decoration: InputDecoration(
                  labelText: 'Nombre de Usuario',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                  suffixIcon: _isUsernameValid
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.clear, color: Colors.red),
                ),
                style: TextStyle(color: textColor),
                onChanged: (value) {
                  _verificarNombreUsuario();
                },
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 10.0,
                    spreadRadius: 1.9,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _correoController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
                readOnly: true,
              ),
            ),
            if (_usernameError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _usernameError,
                  style: TextStyle(
                    color: _isUsernameValid ? Colors.green : Colors.red,
                  ),
                ),
              ),
            SizedBox(height: 30.0),
            Center(
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: _isUsernameValid ? _guardarCambios : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Guardar cambios',
                    style: TextStyle(fontSize: 22.0, color: textColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Editar Perfil',
    home: EditarPerfil(),
  ));
}
