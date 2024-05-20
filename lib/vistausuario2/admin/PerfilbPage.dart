
import 'package:astro_app/astroApp.dart';
import 'package:astro_app/pagina/usuario/ajustes.dart';
import 'package:astro_app/pagina/usuario/editar_perfil.dart';
import 'package:astro_app/vistausuario2/ajustesbPage.dart';
import 'package:astro_app/vistausuario2/changepassword.dart';
import 'package:astro_app/vistausuario2/privacidad.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagina de Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1C1C1E),
      ),
      home: PerfiladministradorPage(),
    );
  }
}

class PerfiladministradorPage extends StatefulWidget {
  @override
  _PerfiladministradorPageState createState() =>
      _PerfiladministradorPageState();
}

class _PerfiladministradorPageState extends State<PerfiladministradorPage> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/en/thumb/a/a3/Starbucks_Corporation_Logo_2011.svg/1200px-Starbucks_Corporation_Logo_2011.svg.png',
                          ) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Christian',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'UsuarioAdmin@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 32),
            ProfileSection(
              title: 'Usuario',
              children: [
                ProfileItem(
                  icon: Icons.person,
                  text: 'Datos Personales',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditarPerfil()),
                    );
                  },
                ),
                ProfileItem(
                  icon: Icons.language,
                  text: 'Lenguaje',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguagePage()),
                    );
                  },
                ),
                ProfileItem(
                  icon: Icons.email,
                  text: 'Casilla de Correo',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguagePage()),
                    );
                  },
                ),
                ProfileItem(
                  icon: Icons.policy,
                  text: 'Gestión de Perfiles',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguagePage()),
                    );
                  },
                ),
                ProfileItem(
                  icon: Icons.settings,
                  text: 'Ajustes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AjustesbPage()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ProfileSection(
              title: 'Seguridad',
              children: [
                ProfileItem(
                  icon: Icons.lock,
                  text: 'Contraseña',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PasswordCPage()),
                    );
                  },
                ),
                ProfileItem(
                  icon: Icons.policy,
                  text: 'Politica de Privadidad',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage()),
                    );
                  },
                ),
                ProfileItem(
                  icon: Icons.logout,
                  text: 'Cerrar Sesion',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AstroApp()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(text, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }
}

// Asegúrate de definir las siguientes clases con el contenido de tus vistas:

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Language')),
      body: Center(child: Text('Language Page')),
    );
  }
}
