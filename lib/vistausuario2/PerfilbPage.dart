import 'package:astro_app/astroApp.dart';
import 'package:astro_app/pagina/usuario/ajustes.dart';
import 'package:astro_app/pagina/usuario/editar_perfil.dart';
import 'package:astro_app/vistausuario2/admin/theme.dart';
import 'package:astro_app/vistausuario2/ajustesbPage.dart';
import 'package:astro_app/vistausuario2/changepassword.dart';
import 'package:astro_app/vistausuario2/privacidad.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración
import 'dart:io';

class PerfilbPage extends StatefulWidget {
  @override
  _PerfilbPageState createState() => _PerfilbPageState();
}

class _PerfilbPageState extends State<PerfilbPage> {
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

  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(
          duration: 50); // Duración de la vibración en milisegundos
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        final Color emailTextColor =
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[300]!
                : const Color.fromARGB(255, 3, 2, 2);

        return Scaffold(
          backgroundColor: themeNotifier.value == ThemeMode.dark
              ? Color(0xFF1C1C1E)
              : Color.fromARGB(255, 255, 255, 255),
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
                          onTap: () {
                            _pickImage();
                            _vibrate(); // Activar vibración al tocar el botón
                          },
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
                  'Sanzana',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'UsuarioNormal@gmail.com',
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
                          MaterialPageRoute(
                              builder: (context) => EditarPerfil()),
                        );
                        _vibrate(); // Activar vibración al tocar el botón
                      },
                    ),
                    ProfileItem(
                      icon: Icons.language,
                      text: 'Lenguaje',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguagePage()),
                        );
                        _vibrate(); // Activar vibración al tocar el botón
                      },
                    ),
                    ProfileItem(
                      icon: Icons.settings,
                      text: 'Ajustes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AjustesbPage()),
                        );
                        _vibrate(); // Activar vibración al tocar el botón
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
                          MaterialPageRoute(
                              builder: (context) => PasswordCPage()),
                        );
                        _vibrate(); // Activar vibración al tocar el botón
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
                        _vibrate(); // Activar vibración al tocar el botón
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
                        _vibrate(); // Activar vibración al tocar el botón
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
    final Color containerColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2C2C2E)
        : Color(0xFFFFFFFF);
    final Color shadowColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(177, 255, 22, 22)
        : Colors.black26;

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
      onTap: () {
        onTap();
        Vibration.vibrate(duration: 50); // Activar vibración al tocar el botón
      },
    );
  }
}

// Asegúrate de definir las siguientes clases con el contenido de tus vistas:
class PersonalDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Data')),
      body: Center(child: Text('Personal Data Page')),
    );
  }
}

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Language')),
      body: Center(child: Text('Language Page')),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(child: Text('Notifications Page')),
    );
  }
}

class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Password')),
      body: Center(child: Text('Password Page')),
    );
  }
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log out')),
      body: Center(child: Text('Log out Page')),
    );
  }
}
