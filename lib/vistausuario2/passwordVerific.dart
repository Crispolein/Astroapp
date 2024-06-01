import 'package:astro_app/common/common.dart';
import 'package:astro_app/router/router.dart';
import 'package:astro_app/pagina/fade_animationtest.dart';
import 'package:astro_app/widgets/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración

class TickedPage extends StatefulWidget {
  const TickedPage({super.key});

  @override
  State<TickedPage> createState() => _TickedPageState();
}

class _TickedPageState extends State<TickedPage> {
  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(
          duration: 50); // Duración de la vibración en milisegundos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFE8ECF4),
      body: SafeArea(
        child: Column(
          children: [
            LottieBuilder.asset("assets/images/ticker.json"),
            FadeInAnimation(
              delay: 1,
              child: Text(
                "Contraseña Cambiada",
                style: Common().titelTheme,
              ),
            ),
            FadeInAnimation(
              delay: 1.5,
              child: Text(
                "Tu contraseña fue cambiada con éxito",
                style: Common().mediumThemeblack,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FadeInAnimation(
              delay: 2,
              child: CustomElevatedButton(
                message: "Volver al inicio",
                function: () {
                  _vibrate(); // Activar vibración al presionar el botón
                  GoRouter.of(context).pushReplacement(Routers.homebpage.name);
                },
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
