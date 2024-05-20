import 'package:astro_app/common/common.dart';
import 'package:astro_app/router/router.dart';
import 'package:astro_app/pagina/fade_animationtest.dart';
import 'package:astro_app/widgets/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class TickedadminPage extends StatefulWidget {
  const TickedadminPage({super.key});

  @override
  State<TickedadminPage> createState() => _TickedadminPageState();
}

class _TickedadminPageState extends State<TickedadminPage> {
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
                "Tu contraseña fue cambiada con exito",
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
