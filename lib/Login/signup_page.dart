import 'package:astro_app/common/common.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/pagina/fade_animationtest.dart';
import 'package:astro_app/widgets/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bcrypt/bcrypt.dart'; // Añadir el paquete bcrypt

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _usernameController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationpasswordController = TextEditingController();
  String _error = '';
  bool _obscurePassword = true;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _usuariosCollection =
      FirebaseFirestore.instance.collection('usuarios');

  // Función para comprobar si el correo electrónico ya está en uso
  Future<bool> correoYaExiste(String correo) async {
    final result =
        await _usuariosCollection.where('correo', isEqualTo: correo).get();
    return result.docs.isNotEmpty;
  }

  // Función para comprobar si el nombre de usuario ya está en uso
  Future<bool> usernameYaExiste(String username) async {
    final result =
        await _usuariosCollection.where('username', isEqualTo: username).get();
    return result.docs.isNotEmpty;
  }

  // Función para registrar un nuevo usuario
  Future<UserCredential> registerNewUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'La contraseña proporcionada es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        throw 'Error al crear usuario, el correo ya existe';
      }
      throw 'Error al crear usuario: $e';
    } catch (e) {
      throw 'Error inesperado: $e';
    }
  }

  // Función para hashear la contraseña
  String hashPassword(String password) {
    final String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(232, 236, 244, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInAnimation(
                delay: 0.6,
                child: IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      size: 35,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      delay: 0.9,
                      child: Text(
                        "Bienvenido! ",
                        style: Common().titelTheme,
                      ),
                    ),
                    FadeInAnimation(
                      delay: 1.2,
                      child: Text(
                        "Empecemos con algunos datos",
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
                        delay: 1.5,
                        child: CustomTextFormField(
                          controller: _nombreController,
                          hinttext: 'Nombre',
                          obsecuretext: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingrese su nombre';
                            }
                            if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                              return 'Ingrese solo letras en el nombre';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 1.5,
                        child: CustomTextFormField(
                          controller: _apellidoController,
                          hinttext: 'Apellido',
                          obsecuretext: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingrese su Apellido';
                            }
                            if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                              return 'Ingrese solo letras en el Apellido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 1.5,
                        child: CustomTextFormField(
                          controller: _usernameController,
                          hinttext: 'Nombre de usuario',
                          obsecuretext: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingresa un nombre de usuario';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 1.8,
                        child: CustomTextFormField(
                          controller: _correoController,
                          hinttext: 'Correo',
                          obsecuretext: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingrese su correo';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Ingrese un correo válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 2.1,
                        child: CustomTextFormField(
                          controller: _passwordController,
                          hinttext: 'Contraseña',
                          obsecuretext: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingrese su contraseña';
                            }
                            if (value.length < 8) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 2.4,
                        child: CustomTextFormField(
                          controller: _confirmationpasswordController,
                          hinttext: 'Confirmar Contraseña',
                          obsecuretext: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor confirme su contraseña';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInAnimation(
                        delay: 2.7,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool correoExiste =
                                  await correoYaExiste(_correoController.text);
                              bool usernameExiste = await usernameYaExiste(
                                  _usernameController.text);
                              if (correoExiste) {
                                setState(() {
                                  _error = 'El correo ya está en uso';
                                });
                              } else if (usernameExiste) {
                                setState(() {
                                  _error =
                                      'El nombre de usuario ya está en uso';
                                });
                              } else {
                                try {
                                  UserCredential user = await registerNewUser(
                                      _correoController.text,
                                      _passwordController.text);
                                  final hashedPassword =
                                      hashPassword(_passwordController.text);
                                  final nuevoUsuario = Usuarios(
                                    id: user.user!.uid,
                                    nombre: _nombreController.text,
                                    apellido: _apellidoController.text,
                                    username: _usernameController.text,
                                    correo: _correoController.text,
                                    password: hashedPassword,
                                    permisos: 0,
                                  );
                                  await _usuariosCollection
                                      .add(nuevoUsuario.toMap());
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Te has registrado correctamente')),
                                  );
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                } catch (e) {
                                  setState(() {
                                    _error = ' $e';
                                  });
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
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
                  height: 160,
                  width: double.infinity,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        delay: 2.9,
                        child: Text(
                          "O Registrarse con...",
                          style: Common().semiboldblack,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const FadeInAnimation(
                        delay: 3.2,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, right: 30, left: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),
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
}
