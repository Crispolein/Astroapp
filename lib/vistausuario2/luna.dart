import 'package:flutter/material.dart';

// Importamos las extensiones y clases para las fases lunares
extension JulianDate on DateTime {
  bool get isLeapYear {
    if (year % 400 == 0) {
      return true;
    } else if (year % 100 == 0) {
      return false;
    } else if (year % 4 == 0) {
      return true;
    }
    return false;
  }

  int get dayNumber {
    var month = this.month;
    if (month > 2) {
      month += 1;
      month = (month.toDouble() * 30.6).toInt();
      month = isLeapYear ? month -= 62 : month -= 63;
    } else {
      month -= 1;
      month = isLeapYear ? month * 62 : month * 63;
      month = month ~/ 2;
    }
    month += day;
    return month;
  }

  double get dayAsFraction {
    return day.toDouble() + (hour / 24.0);
  }

  double get julianDate {
    var utcnow = toUtc();
    var yPrime;
    var mPrime;
    if (utcnow.month == 1 || utcnow.month == 2) {
      yPrime = year - 1;
      mPrime = month + 12;
    } else {
      yPrime = year;
      mPrime = month;
    }

    var compare = DateTime(1582, 10, 15).toUtc();
    int A;
    int B;
    int C;
    int D;
    if (utcnow.isAfter(compare)) {
      A = yPrime ~/ 100;
      B = 2 - A + (A ~/ 4);
    } else {
      B = 0;
    }

    if (yPrime < 0) {
      C = ((365.25 * yPrime) - 0.75).floor();
    } else {
      C = (365.25 * yPrime).floor();
    }
    D = (30.6001 * (mPrime + 1)).floor();
    return B.toDouble() +
        C.toDouble() +
        D.toDouble() +
        dayAsFraction +
        1720994.5;
  }
}

class Moon {
  static String phase(DateTime input) {
    var D = ageOfMoon(input);
    return getMoonPhase(D);
  }

  static double ageOfMoon(DateTime input) {
    const lunarCycle = 29.530588853;
    final lastNewMoon = DateTime(2019, 1, 6, 1, 29);
    final daysSinceLastNewMoon = input.julianDate - lastNewMoon.julianDate;
    final newMoons = daysSinceLastNewMoon / lunarCycle;
    return (newMoons - newMoons.floor()) * lunarCycle;
  }

  static String getMoonPhase(double daysSinceNewMoon) {
    if (daysSinceNewMoon == 0 || daysSinceNewMoon >= 29.5) {
      return 'New Moon';
    }

    if (daysSinceNewMoon > 0 && daysSinceNewMoon < 3.5) {
      return 'New Moon';
    }

    if (daysSinceNewMoon >= 3.5 && daysSinceNewMoon < 7) {
      return 'Waxing Crescent';
    }

    if (daysSinceNewMoon >= 7 && daysSinceNewMoon < 11) {
      return 'First Quarter';
    }

    if (daysSinceNewMoon >= 11 && daysSinceNewMoon < 15.0) {
      return 'Waxing Gibbous';
    }

    if (daysSinceNewMoon >= 15.0 && daysSinceNewMoon < 18.5) {
      return 'Full Moon';
    }

    if (daysSinceNewMoon >= 18.5 && daysSinceNewMoon < 22.0) {
      return 'Waning Gibbous';
    }

    if (daysSinceNewMoon >= 22.0 && daysSinceNewMoon < 25.7) {
      return 'Last Quarter';
    }

    if (daysSinceNewMoon >= 25.7 && daysSinceNewMoon < 29.5) {
      return 'Waning Crescent';
    }
    return 'Error';
  }
}

// Importamos el modelo de fase lunar
class FaseLunar {
  final String fecha;
  final String imagen;

  FaseLunar({
    required this.fecha,
    required this.imagen,
  });
}

// Función para obtener la fase lunar
Future<FaseLunar> fetchMoonPhase(
    String latitude, String longitude, String date) async {
  // Implementa la lógica para obtener la fase lunar según la ubicación y la fecha
  DateTime now = DateTime.parse(date);
  String moonPhase = Moon.phase(now);

  // Dependiendo de la fase lunar, selecciona la imagen correspondiente
  String imageUrl = 'https://tu-servidor.com/imagen_$moonPhase.jpg';

  // Retornamos la fase lunar con la fecha y la imagen
  return FaseLunar(
    fecha: now.toString(),
    imagen: imageUrl,
  );
}

// Implementación del widget de la página de la fase lunar
class FaseLunarPage extends StatefulWidget {
  @override
  _FaseLunarPageState createState() => _FaseLunarPageState();
}

class _FaseLunarPageState extends State<FaseLunarPage> {
  Future<FaseLunar>? _faseLunarFuturo;

  @override
  void initState() {
    super.initState();
    _faseLunarFuturo = fetchMoonPhase("37.7749", "-122.4194", "2024-05-24");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fase Lunar")),
      body: FutureBuilder<FaseLunar>(
        future: _faseLunarFuturo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final faseLunar = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fecha: ${faseLunar.fecha}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Image.network(faseLunar.imagen),
              ],
            );
          } else {
            return Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}
