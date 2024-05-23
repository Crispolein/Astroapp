import 'package:astro_app/common/common.dart';
import 'package:astro_app/router/router.dart';
import 'package:astro_app/pagina/fade_animationtest.dart';
import 'package:astro_app/widgets/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordCPage extends StatefulWidget {
  const PasswordCPage({super.key});

  @override
  State<PasswordCPage> createState() => _PasswordCPageState();
}

class _PasswordCPageState extends State<PasswordCPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        await user?.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña actualizada con éxito')),
        );
        GoRouter.of(context).pushNamed(Routers.tickedpage.name);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la contraseña: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInAnimation(
                delay: 1,
                child: IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
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
                        "Crear Nueva Contraseña",
                        style: Common().titelTheme,
                      ),
                    ),
                    FadeInAnimation(
                      delay: 1.6,
                      child: Text(
                        "Tu nueva contraseña debe ser única respecto a las que se han utilizado previamente.",
                        style: Common().mediumThemeblack,
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
                          controller: _newPasswordController,
                          hinttext: 'Nueva Contraseña',
                          obsecuretext: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nueva contraseña';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FadeInAnimation(
                        delay: 2.1,
                        child: CustomTextFormField(
                          controller: _confirmPasswordController,
                          hinttext: 'Confirmar Contraseña',
                          obsecuretext: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu nueva contraseña';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInAnimation(
                        delay: 2.4,
                        child: CustomElevatedButton(
                          message: "Resetear Contraseña",
                          function: _changePassword,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FadeInAnimation(
                delay: 2.5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
