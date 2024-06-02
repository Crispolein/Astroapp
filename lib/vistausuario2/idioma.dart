import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double padding = 16.0; // Ajusta este valor según tus necesidades

    return Scaffold(
      appBar: AppBar(title: Text('Idiomas')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'En próximas actualizaciones',
            style: GoogleFonts.pacifico(
              // Usa la fuente divertida que prefieras
              fontSize: 24, // Ajusta el tamaño según tus necesidades
              color: Colors.blue, // Ajusta el color según tus necesidades
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Lottie.asset(
              'assets/images/Hamster.json', // Ruta del archivo JSON de la animación Lottie
              width: MediaQuery.of(context).size.width - padding * 2,
              height: MediaQuery.of(context).size.height /
                  2, // Ajusta la altura según tus necesidades
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
