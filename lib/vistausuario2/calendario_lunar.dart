import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class LunarCalendar extends StatefulWidget {
  final int year;
  final int month;

  LunarCalendar({required this.year, required this.month});

  @override
  _LunarCalendarState createState() =>
      _LunarCalendarState(year: year, month: month);
}

class _LunarCalendarState extends State<LunarCalendar> {
  Map<String, dynamic> moonPhases = {};
  int year;
  int month;
  DateTime today = DateTime.now();

  _LunarCalendarState({required this.year, required this.month}) : super();

  @override
  void initState() {
    super.initState();
    year = widget.year;
    month = widget.month;
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

  void nextMonth() {
    setState(() {
      if (month == 12) {
        month = 1;
        year++;
      } else {
        month++;
      }
      fetchMoonPhases();
    });
  }

  void previousMonth() {
    setState(() {
      if (month == 1) {
        month = 12;
        year--;
      } else {
        month--;
      }
      fetchMoonPhases();
    });
  }

  String formatMonthYear(int year, int month) {
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
    return '${months[month - 1]} $year';
  }

  Widget buildCalendar() {
    List<String> weekdays = ['lu', 'ma', 'mi', 'ju', 'vi', 'sá', 'do'];
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstWeekdayOfMonth = DateTime(year, month, 1).weekday;

    List<Widget> dayWidgets = [];
    List<Widget> weekDayWidgets = weekdays
        .map((day) => Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(4.0),
              ),
              margin: EdgeInsets.all(2.0),
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ))
        .toList();

    // Adjust for the weekday offset (Monday = 1, Sunday = 7)
    for (int i = 0; i < (firstWeekdayOfMonth + 6) % 7; i++) {
      dayWidgets.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(''),
        ),
      ));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      String svgContent = '';
      if (moonPhases[day.toString()] != null &&
          moonPhases[day.toString()]['svg'] != null) {
        svgContent = moonPhases[day.toString()]['svg'];
      }

      bool isToday =
          today.year == year && today.month == month && today.day == day;

      dayWidgets.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: isToday ? Colors.yellowAccent : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(day.toString()),
              if (svgContent.isNotEmpty)
                SvgPicture.string(
                  svgContent,
                  height: 25,
                  width: 25,
                ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDayWidgets,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              children: dayWidgets,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario Lunar'),
      ),
      body: moonPhases.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: previousMonth,
                    ),
                    Text(
                      formatMonthYear(year, month),
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: nextMonth,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                buildCalendar(),
              ],
            ),
    );
  }
}
