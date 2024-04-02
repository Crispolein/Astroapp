import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController correoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: correoController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                hintText: 'Correo',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo "Correo" no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                hintText: 'Contraseña',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo "Contraseña" no puede estar vacío';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                _signInWithEmailAndPassword();
              },
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {}
  }
}
