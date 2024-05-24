import 'package:flutter/material.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/api/faseluna.dart';

class FaseLunarPage extends StatefulWidget {
  @override
  _FaseLunarPageState createState() => _FaseLunarPageState();
}

class _FaseLunarPageState extends State<FaseLunarPage> {
  late PageController _pageController;
  Future<List<FaseLunar>>? _fasesLunaresFuturo;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fasesLunaresFuturo = fetchFasesLunares("37.7749", "-122.4194",
        "2024-01-01", "2024-12-31"); // Replace with desired dates and location
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
                image: NetworkImage(faseLunar.imagen),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                faseLunar.fase,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 5),
              Text(
                'Fase Lunar',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Iluminación: ${faseLunar.iluminacion}',
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          Text(
            'Edad de la Luna: ${faseLunar.edadLuna}',
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
