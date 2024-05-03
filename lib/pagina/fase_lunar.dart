import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Creamos una lista de nombres para cada fase lunar
final List<String> lunarPhases = [
  "Luna Nueva",
  "Cuarto Creciente",
  "Luna Llena",
  "Cuarto Menguante",
];

// Creamos una lista de imágenes para representar cada fase lunar (esto podría cambiar dependiendo de tus recursos)
final List<String> lunarPhaseImages = [
  "assets/nueva.png",
  "assets/creciente.png",
  "assets/llena.png",
  "assets/menguante.png",
];

// Función para calcular la fase lunar actual
String calcularFaseLunar(DateTime date) {
  // Aquí podrías usar algún algoritmo para calcular la fase lunar basado en la fecha
  // Pero para simplificar, vamos a utilizar una estimación basada en el día del mes
  int day = date.day;
  int phaseIndex = (day / 7).floor() % 4;
  return lunarPhases[phaseIndex];
}

// Vista de la aplicación Flutter
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Fase Lunar'),
      ),
      body: Center(
        child: FaseLunar(),
      ),
    ),
  ));
}

class FaseLunar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String phase = calcularFaseLunar(now);
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    int phaseIndex = lunarPhases.indexOf(phase);
    String phaseImage = lunarPhaseImages[phaseIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Fase Lunar Actual:',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          phase,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        Image.asset(
          phaseImage,
          width: 150,
          height: 150,
        ),
        SizedBox(height: 20),
        Text(
          'Fecha: $formattedDate',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
