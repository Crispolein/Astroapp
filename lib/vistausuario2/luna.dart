import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fases Lunares',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaselunarPage(),
    );
  }
}

class FaselunarPage extends StatefulWidget {
  @override
  _FaselunarPageState createState() => _FaselunarPageState();
}

class _FaselunarPageState extends State<FaselunarPage> {
  late PageController _pageController;
  Future<List<FaseLunar>>? _fasesLunaresFuturo;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fasesLunaresFuturo = obtenerFasesLunares();
  }

  Future<List<FaseLunar>> obtenerFasesLunares() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/images/luna.json');
    final List<dynamic> data = json.decode(jsondata);
    return data.map((json) => FaseLunar.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<FaseLunar>>(
        future: _fasesLunaresFuturo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final fasesLunares = snapshot.data ?? [];
            return PageView.builder(
              controller: _pageController,
              itemCount: fasesLunares.length,
              itemBuilder: (context, index) {
                final faseLunar = fasesLunares[index];
                return PaginaFaseLunar(
                  faseLunar: faseLunar,
                  pageController: _pageController,
                  itemCount: fasesLunares.length,
                  currentIndex: index,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PaginaFaseLunar extends StatelessWidget {
  final FaseLunar faseLunar;
  final PageController pageController;
  final int itemCount;
  final int currentIndex;

  PaginaFaseLunar({
    required this.faseLunar,
    required this.pageController,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (currentIndex > 0)
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              Spacer(),
              Column(
                children: [
                  Text(
                    faseLunar.fecha,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    faseLunar.dia,
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              if (currentIndex < itemCount - 1)
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(faseLunar.imagen),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinear los textos a la izquierda
            children: [
              Align(
                alignment:
                    Alignment.centerLeft, // Alinea el texto a la izquierda
                child: Text(
                  faseLunar.fase,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left, // Alinea el texto a la izquierda
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment:
                    Alignment.centerLeft, // Alinea el texto a la izquierda
                child: Text(
                  'Fase Lunar',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.left, // Alinea el texto a la izquierda
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
            child: Text(
              'Iluminación: ${faseLunar.iluminacion}',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.left, // Alinea el texto a la izquierda
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
            child: Text(
              'Edad de la Luna: ${faseLunar.edadLuna}',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.left, // Alinea el texto a la izquierda
            ),
          ),
        ],
      ),
    );
  }
}

class FaseLunar {
  final String fecha;
  final String dia;
  final String fase;
  final String iluminacion;
  final String edadLuna;
  final String imagen;

  FaseLunar({
    required this.fecha,
    required this.dia,
    required this.fase,
    required this.iluminacion,
    required this.edadLuna,
    required this.imagen,
  });

  factory FaseLunar.fromJson(Map<String, dynamic> json) {
    return FaseLunar(
      fecha: json['date'],
      dia: json['day'],
      fase: json['phase'],
      iluminacion: json['illumination'],
      edadLuna: json['moon_age'],
      imagen: json['image'],
    );
  }
}
