// ignore_for_file: use_build_context_synchronously

import 'package:astro_app/common/common.dart';
import 'package:astro_app/router/router.dart';
import 'package:astro_app/pagina/fade_animationtest.dart';
import 'package:astro_app/widgets/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInAnimation(
                delay: 1,
                child: IconButton(
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(Routers.authenticationpage.name);
                  },
                  icon: const Icon(
                    CupertinoIcons.back,
                    size: 35,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      delay: 1.3,
                      child: Text(
                        "Bienvenido devuelta",
                        style: Common().titelTheme,
                      ),
                    ),
                    FadeInAnimation(
                      delay: 1.6,
                      child: Text(
                        "Ojala recuerdes esto:",
                        style: Common().titelTheme,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        delay: 1.9,
                        child: CustomTextFormField(
                          controller: emailController,
                          hinttext: 'Ingresa tu correo',
                          obsecuretext: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Rellena el campo 'correo'";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 2.2,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: flag ? true : false,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: "Ingresa tu contraseña",
                            hintStyle: Common().hinttext,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_red_eye_outlined),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Rellena el campo 'contraseña'";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 2.5,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context)
                                  .pushNamed(Routers.forgetpassword.name);
                            },
                            child: const Text(
                              "¿Olvidaste la contraseña?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Urbanist-SemiBold",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 2.8,
                        child: ElevatedButton(
                          onPressed: () {
                            _signInWithEmailAndPassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Iniciar Sesion'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        delay: 2.2,
                        child: Text(
                          "O ingresar con...",
                          style: Common().semiboldblack,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const FadeInAnimation(
                        delay: 2.4,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, right: 30, left: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeInAnimation(
                delay: 2.8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "¿No puede ingresar sesion?",
                        style: Common().hinttext,
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(Routers.signuppage.name);
                        },
                        child: Text(
                          "Registrate AHORA",
                          style: Common().mediumTheme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de validación'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getUserInfo(String uid) async {
    Map<String, dynamic> userInfo = {};

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('id', isEqualTo: uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot = snapshot.docs[0];
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null &&
            userData.containsKey('permisos') &&
            userData.containsKey('nombre') &&
            userData.containsKey('apellido')) {
          userInfo = {
            'permisos': userData['permisos'],
            'nombre': userData['nombre'],
            'apellido': userData['apellido'],
          };
        }
      } else {
        print('No se encontro el usuario');
      }
    } catch (e) {
      print('Error al obtener la informacion del usuario: $e');
    }
    return userInfo;
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Map<String, dynamic>? userInfo =
            await _getUserInfo(userCredential.user!.uid);

        if (userInfo['permisos'] == 1) {
          GoRouter.of(context).pushNamed(Routers.homepage.name);
        } else if (userInfo['permisos'] == 0) {
          GoRouter.of(context).pushNamed(Routers.addquestionpageadmin.name);
        } else {
          _showErrorDialog('No se encontró el rol del usuario.');
        }
      } catch (e) {
        // Error durante el inicio de sesión, mostrar mensaje de error
        String errorMessage =
            'Error durante el inicio de sesión. Por favor, verifica tus credenciales.';
        if (e is FirebaseAuthException && e.code == 'user-not-found') {
          errorMessage = 'No se encontró un usuario con estas credenciales.';
        } else if (e is FirebaseAuthException && e.code == 'wrong-password') {
          errorMessage = 'Contraseña incorrecta.';
        }
        _showErrorDialog(errorMessage);
      }
    } else {
      // Campos no válidos, mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese los datos requeridos'),
        ),
      );
    }
  }
}
