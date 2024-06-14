import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double padding = 16.0; 

    return Scaffold(
      appBar: AppBar(title: Text('Idiomas')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'En próximas actualizaciones',
            style: GoogleFonts.pacifico(
              fontSize: 24, 
              color: Colors.blue, 
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Lottie.asset(
              'assets/images/Hamster.json', 
              width: MediaQuery.of(context).size.width - padding * 2,
              height: MediaQuery.of(context).size.height /
                  2, 
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
