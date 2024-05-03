import 'dart:io';

import 'package:flutter/material.dart';

class VerPerfilAdmin extends StatelessWidget {
  final String nombre;
  final String correo;
  final int edad;
  final String descripcion;
  final File? imagen;

  VerPerfilAdmin({
    required this.nombre,
    required this.correo,
    required this.edad,
    required this.descripcion,
    this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Perfil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      Colors.grey[300], // Color de fondo de la foto de perfil
                ),
                child: imagen != null
                    ? ClipOval(
                        child: Image.file(
                          imagen!,
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 150,
                        color: Colors.grey[
                            600], // Color del icono de perfil predeterminado
                      ), // Icono de perfil predeterminado
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Nombre:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              nombre,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Correo:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              correo,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Edad:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              edad.toString(),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Descripción:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              descripcion,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
