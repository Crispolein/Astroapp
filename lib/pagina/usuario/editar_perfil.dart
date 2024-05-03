import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarPerfil extends StatefulWidget {
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  String _nombre = '';
  String _correo = '';
  int _edad = 18; // Inicializar con una edad por defecto (por ejemplo, 18 años)
  String _descripcion = '';
  File? _image;
  List<int> _edades = List<int>.generate(
      100, (int index) => index + 1); // Lista de edades del 1 al 100

  // Función para guardar los cambios en el perfil
  void _guardarCambios() {
    // Aquí podrías guardar los cambios en tu backend o base de datos
    // Puedes usar los valores de _nombre, _correo, _edad, _descripcion
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor:
            Colors.blueAccent, // Cambio de color de la barra de navegación
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _guardarCambios,
          ),
        ],
      ),
      backgroundColor: Colors.white, // Fondo de pantalla blanco
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
                    color:
                        Colors.grey[300], // Color de fondo de la foto de perfil
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
                          color: Colors.grey[
                              700], // Cambio de color del icono de la cámara
                        ), // Placeholder de la foto de perfil
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[
                    300], // Cambio de color del contenedor de entrada de texto
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
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
                color: Colors.grey[
                    300], // Cambio de color del contenedor de entrada de texto
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
                initialValue: _correo,
                onChanged: (value) {
                  setState(() {
                    _correo = value;
                  });
                },
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[
                    300], // Cambio de color del contenedor de entrada de texto
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
                value: _edad,
                onChanged: (value) {
                  setState(() {
                    _edad = value!;
                  });
                },
                items: _edades.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[
                    300], // Cambio de color del contenedor de entrada de texto
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                initialValue: _descripcion,
                onChanged: (value) {
                  setState(() {
                    _descripcion = value;
                  });
                },
                maxLines: 4,
              ),
            ),
            SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardarCambios,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blueAccent, // Cambio de color del botón
                ),
                child: Text(
                  'Guardar cambios',
                  style: TextStyle(fontSize: 20.0),
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
