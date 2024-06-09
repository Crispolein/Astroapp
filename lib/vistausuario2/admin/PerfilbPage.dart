import 'package:astro_app/astroApp.dart';
import 'package:astro_app/pagina/admin/editar_perfil_Admin.dart';
import 'package:astro_app/vistausuario2/admin/ajustesbPage.dart';
import 'package:astro_app/vistausuario2/admin/theme.dart';
import 'package:astro_app/vistausuario2/changepassword.dart';
import 'package:astro_app/vistausuario2/idioma.dart';
import 'package:astro_app/vistausuario2/privacidad.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  String? _correo;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Obtén el correo del usuario autenticado
      setState(() {
        _correo = user.email;
      });

      // Consulta Firestore para obtener el nombre de usuario
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      setState(() {
        _username = userDoc['username'];
      });
    }
  }

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
        final Color iconColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.amber
            : Colors.purple;

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
                  _username ?? 'Cargando...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  _correo ?? 'Cargando...',
                  style: TextStyle(fontSize: 16, color: emailTextColor),
                ),
                SizedBox(height: 32),
                ProfileSection(
                  title: 'Usuario',
                  children: [
                    ProfileItem(
                      icon: Icons.person,
                      iconColor: iconColor,
                      text: 'Datos Personales',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditarAdminPerfil()),
                        );
                      },
                    ),
                    ProfileItem(
                      icon: Icons.language,
                      iconColor: iconColor,
                      text: 'Lenguaje',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguagePage()),
                        );
                      },
                    ),
                    ProfileItem(
                      icon: Icons.settings,
                      iconColor: iconColor,
                      text: 'Ajustes',
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
                  title: 'Seguridad',
                  children: [
                    ProfileItem(
                      icon: Icons.lock,
                      iconColor: iconColor,
                      text: 'Contraseña',
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
                      iconColor: iconColor,
                      text: 'Politica de Privacidad',
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
                      iconColor: iconColor,
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
  final Color iconColor;
  final String text;
  final VoidCallback onTap;

  const ProfileItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text),
      trailing: Icon(Icons.arrow_forward,
          color: iconColor), // Add trailing arrow icon
      onTap: onTap,
    );
  }
}
