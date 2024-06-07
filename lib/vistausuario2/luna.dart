import 'package:astro_app/vistausuario2/calendario_lunar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class MoonPhaseViewer extends StatefulWidget {
  @override
  _MoonPhaseViewerState createState() => _MoonPhaseViewerState();
}

class _MoonPhaseViewerState extends State<MoonPhaseViewer> {
  Map<String, dynamic> moonPhases = {};
  DateTime currentDate = DateTime.now();
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
      });
    } else {
      throw Exception('Failed to load moon phases');
    }
  }

  void nextDay() {
    setState(() {
      currentDate = currentDate.add(Duration(days: 1));
      if (currentDate.month != month) {
        month = currentDate.month;
        year = currentDate.year;
        fetchMoonPhases();
      }
    });
  }

  void previousDay() {
    setState(() {
      currentDate = currentDate.subtract(Duration(days: 1));
      if (currentDate.month != month) {
        month = currentDate.month;
        year = currentDate.year;
        fetchMoonPhases();
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
        automaticallyImplyLeading: false, // Remove the back arrow
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0), // Lower the title
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: previousDay,
              ),
              Spacer(), // To push the title to the center
              Text('Fase Lunar'),
              Spacer(), // To push the arrow to the right
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: nextDay,
              ),
            ],
          ),
        ),
      ),
      body: moonPhases.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatDate(currentDate),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                moonPhases[currentDate.day.toString()] != null
                    ? SvgPicture.string(
                        moonPhases[currentDate.day.toString()]['svg'],
                        height: 250, // Increased height
                        width: 250, // Increased width
                      )
                    : Container(),
                SizedBox(height: 20),
                Text(
                  'Creciente: ${moonPhases[currentDate.day.toString()]['lighting']}%',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LunarCalendar(year: year, month: month)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      child: Text(
                        'Calendario Lunar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
