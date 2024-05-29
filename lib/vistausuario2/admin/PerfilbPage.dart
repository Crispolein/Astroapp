import 'package:astro_app/astroApp.dart';
import 'package:astro_app/pagina/usuario/ajustes.dart';
import 'package:astro_app/pagina/usuario/editar_perfil.dart';
import 'package:astro_app/vistausuario2/admin/ajustesbPage.dart';
import 'package:astro_app/vistausuario2/admin/correo.dart';
import 'package:astro_app/vistausuario2/admin/gestiondeperfiles.dart';
import 'package:astro_app/vistausuario2/admin/theme.dart';
import 'package:astro_app/vistausuario2/ajustesbPage.dart';
import 'package:astro_app/vistausuario2/changepassword.dart';
import 'package:astro_app/vistausuario2/privacidad.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('es'),
        Locale('ja'),
        Locale('pt'),
        Locale('de')
      ],
      path: 'assets/localizations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      title: tr('Pagina de Admin'),
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
                  tr('Christian'),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'UsuarioAdmin@gmail.com',
                  style: TextStyle(fontSize: 16, color: emailTextColor),
                ),
                SizedBox(height: 32),
                ProfileSection(
                  title: tr('Usuario'),
                  children: [
                    ProfileItem(
                      icon: Icons.person,
                      text: tr('Datos Personales'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditarPerfil()),
                        );
                      },
                    ),
                    ProfileItem(
                      icon: Icons.language,
                      text: tr('Lenguaje'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguagePage()),
                        );
                      },
                    ),
                    ProfileItem(
                      icon: Icons.email,
                      text: tr('Casilla de Correo'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CasillaDeCorreoPage()),
                        );
                      },
                    ),
                    ProfileItem(
                      icon: Icons.policy,
                      text: tr('Gestión de Perfiles'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GestionDePerfilesPage()),
                        );
                      },
                    ),
                    ProfileItem(
                      icon: Icons.settings,
                      text: tr('Ajustes'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AjustesadminPage()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ProfileSection(
                  title: tr('Seguridad'),
                  children: [
                    ProfileItem(
                      icon: Icons.lock,
                      text: tr('Contraseña'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordCPage()),
                        );
                      },
                    ),
                    ProfileItem(
                      icon: Icons.policy,
                      text: tr('Politica de Privadidad'),
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
                      text: tr('Cerrar Sesion'),
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
    // Determinar el color del contenedor basado en el modo de tema
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
  final bool hasSwitch;
  final bool isEnabled;

  const ProfileItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.hasSwitch = false,
    this.isEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar el color de los iconos basado en el modo de tema
    final Color iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.orange
        : Color(0xFFF8E24AA); // Ajusta el color según sea necesario

    final Color arrowColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : Colors.black; // Ajusta el color según sea necesario

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text, style: TextStyle(fontSize: 16)),
      trailing: hasSwitch
          ? Switch(
              value: isEnabled,
              onChanged: (_) {
                onTap();
              },
            )
          : Icon(Icons.arrow_forward_ios, color: arrowColor),
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
