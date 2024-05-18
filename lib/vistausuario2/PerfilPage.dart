import 'package:astro_app/pagina/usuario/ajustes.dart';
import 'package:astro_app/pagina/usuario/editar_perfil.dart';
import 'package:astro_app/vistausuario2/homeb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  PerfilPageState createState() => PerfilPageState();
}

class PerfilPageState extends State<PerfilPage> with TickerProviderStateMixin {
  AnimationController? _controller;
  ScrollController s = ScrollController();
  List<Color> rainbowColor = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
      value: 0,
      lowerBound: 0,
      upperBound: 80,
    )..addListener(
        () async {
          s.jumpTo((_controller?.value ?? 1) * 5);
        },
      );
  }

  Widget _buildRainbowButton(String text, IconData icon, Widget nextPage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: (MediaQuery.of(context).size.height * 0.1) - 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListView(
              shrinkWrap: true,
              controller: s,
              reverse: true,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1.6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      tileMode: TileMode.repeated,
                      transform: const GradientRotation(0.8),
                      colors: [
                        ...rainbowColor,
                        ...rainbowColor,
                        ...rainbowColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onHover: (s) {
            if (s) {
              _controller?.repeat();
            } else {
              _controller?.stop();
            }
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            width: (MediaQuery.of(context).size.width * 0.5) - 14,
            height: (MediaQuery.of(context).size.height * 0.1) - 20 - 14,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: GoogleFonts.kalam(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/perfil.jpg'),
            ),
            const SizedBox(height: 20),
            _buildRainbowButton("Ver Perfil", Icons.person, EditarPerfil()),
            const SizedBox(height: 20),
            _buildRainbowButton("Editar Perfil", Icons.edit, EditarPerfil()),
            const SizedBox(height: 20),
            _buildRainbowButton(
                "Ajustes del Perfil", Icons.settings, AjustesPage()),
            const SizedBox(height: 20),
            _buildRainbowButton("Volver", Icons.arrow_back, HomebPage()),
          ],
        ),
      ),
    );
  }
}
