import 'package:astro_app/vistausuario2/calendario_lunar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MoonPhaseViewer(),
    );
  }
}

class MoonPhaseViewer extends StatefulWidget {
  @override
  _MoonPhaseViewerState createState() => _MoonPhaseViewerState();
}

class _MoonPhaseViewerState extends State<MoonPhaseViewer> {
  Map<String, dynamic> moonPhases = {};
  int currentDayIndex = 0;
  int year = DateTime.now().year;
  int month = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    fetchMoonPhases();
  }

  Future<void> fetchMoonPhases() async {
    final response = await http.get(Uri.parse(
        'https://www.icalendar37.net/lunar/api/?lang=es&month=$month&year=$year&LDZ=${(DateTime(year, month, 1).millisecondsSinceEpoch / 1000).floor()}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        moonPhases = data['phase'];
        currentDayIndex = DateTime.now().day - 1;
      });
    } else {
      throw Exception('Failed to load moon phases');
    }
  }

  void nextDay() {
    setState(() {
      if (currentDayIndex < moonPhases.length - 1) {
        currentDayIndex++;
      }
    });
  }

  void previousDay() {
    setState(() {
      if (currentDayIndex > 0) {
        currentDayIndex--;
      }
    });
  }

  String formatDate(DateTime date) {
    List<String> days = [
      'domingo',
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado'
    ];
    List<String> months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    String day = days[date.weekday % 7];
    String month = months[date.month - 1];
    return '$day ${date.day} de $month';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fase Lunar de Hoy'),
      ),
      body: moonPhases.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: previousDay,
                    ),
                    Text(
                      formatDate(DateTime(year, month, currentDayIndex + 1)),
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: nextDay,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                moonPhases[currentDayIndex.toString()] != null
                    ? SvgPicture.string(
                        moonPhases[currentDayIndex.toString()]['svg'],
                        height: 100,
                        width: 100,
                      )
                    : Container(),
                SizedBox(height: 20),
                Text(
                  'Creciente: ${moonPhases[currentDayIndex.toString()]['lighting']}%',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LunarCalendar(year: year, month: month)),
                    );
                  },
                  child: Text('Calendario Lunar'),
                ),
              ],
            ),
    );
  }
}
