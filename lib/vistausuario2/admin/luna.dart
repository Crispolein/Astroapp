import 'dart:convert';
import 'package:astro_app/vistausuario2/admin/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.value,
          title: 'Fases Lunares',
          home: FaselunaradminPage(),
        );
      },
    );
  }
}

class FaselunaradminPage extends StatefulWidget {
  @override
  _FaselunaradminPageState createState() => _FaselunaradminPageState();
}

class _FaselunaradminPageState extends State<FaselunaradminPage> {
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
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF1C1C1E)
            : Color.fromARGB(255, 255, 255, 255);
    final Color titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.amber
        : Colors.black;
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[300]!
        : Colors.grey[800]!;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Container(
        key: ValueKey<ThemeMode>(themeNotifier.value),
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
        ),
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
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[300]!
        : Colors.black;
    final Color containerColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2C2C2E)
        : Colors.white;
    final Color titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.amber
        : Colors.purple;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (currentIndex > 0)
                IconButton(
                  icon: Icon(Icons.arrow_back, color: titleColor),
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
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),
                  Text(
                    faseLunar.dia,
                    style: TextStyle(fontSize: 24, color: textColor),
                  ),
                ],
              ),
              Spacer(),
              if (currentIndex < itemCount - 1)
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: titleColor),
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
              color: containerColor,
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
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: titleColor),
                  textAlign: TextAlign.left, // Alinea el texto a la izquierda
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment:
                    Alignment.centerLeft, // Alinea el texto a la izquierda
                child: Text(
                  'Fase Lunar',
                  style: TextStyle(fontSize: 18, color: textColor),
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
              style: TextStyle(fontSize: 22, color: textColor),
              textAlign: TextAlign.left, // Alinea el texto a la izquierda
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
            child: Text(
              'Edad de la Luna: ${faseLunar.edadLuna}',
              style: TextStyle(fontSize: 22, color: textColor),
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
