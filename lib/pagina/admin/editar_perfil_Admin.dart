import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarAdminPerfil extends StatefulWidget {
  @override
  _EditarAdminPerfilState createState() => _EditarAdminPerfilState();
}

class _EditarAdminPerfilState extends State<EditarAdminPerfil> {
  String _nombre = '';
  String _apellido = '';
  String _nombreUsuario = '';
  String _correo = '';
  File? _image;

  // Función para guardar los cambios en el perfil
  void _guardarCambios() {
    // Aquí podrías guardar los cambios en tu backend o base de datos
    // Puedes usar los valores de _nombre, _correo, _nombreUsuario, _apellido
    // y realizar las acciones necesarias para actualizar el perfil.
  }

  // Función para seleccionar una foto de la galería
  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  // Función para tomar una foto nueva
  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No se tomó ninguna foto.');
      }
    });
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save, color: textColor),
            onPressed: _guardarCambios,
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Editar Foto de Perfil'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Seleccionar de la galería'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _seleccionarFoto();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Tomar una foto'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _tomarFoto();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: _image != null
                      ? ClipOval(
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          size: 70,
                          color: Colors.grey[700],
                        ),
                ),
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
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
                initialValue: _nombre,
                onChanged: (value) {
                  setState(() {
                    _nombre = value;
                  });
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
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
                initialValue: _apellido,
                onChanged: (value) {
                  setState(() {
                    _apellido = value;
                  });
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
                decoration: InputDecoration(
                  labelText: 'Nombre de Usuario',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
                initialValue: _nombreUsuario,
                onChanged: (value) {
                  setState(() {
                    _nombreUsuario = value;
                  });
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
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
                initialValue: _correo,
                onChanged: (value) {
                  setState(() {
                    _correo = value;
                  });
                },
              ),
            ),
            SizedBox(height: 30.0),
            Center(
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: _guardarCambios,
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
    home: EditarAdminPerfil(),
  ));
}
