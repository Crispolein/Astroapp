import 'package:astro_app/vistausuario2/Quiz/quiz_facil.dart';
import 'package:astro_app/vistausuario2/Quiz/quiz_medio.dart';
import 'package:astro_app/vistausuario2/Quiz/quiz_dificil.dart';
import 'package:astro_app/vistausuario2/TerminosPareados/terminos_pareados_facil.dart';
import 'package:astro_app/vistausuario2/TerminosPareados/terminos_pareados_medio.dart';
import 'package:astro_app/vistausuario2/TerminosPareados/terminos_pareados_dificil.dart';
import 'package:astro_app/vistausuario2/VerdaderoFalso/verdadero_falso_facil.dart';
import 'package:astro_app/vistausuario2/VerdaderoFalso/verdadero_falso_medio.dart';
import 'package:astro_app/vistausuario2/VerdaderoFalso/verdadero_falso_dificil.dart';
import 'package:astro_app/vistausuario2/Memorice/memorice_facil.dart';
import 'package:astro_app/vistausuario2/Memorice/memorice_medio.dart';
import 'package:astro_app/vistausuario2/Memorice/memorice_dificil.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juegos'),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          // Agregar Scrollbar
          child: SingleChildScrollView(
            // Agregar SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategorySection(
                  title: 'Quiz',
                  icon: Icons.check_circle,
                  items: [
                    CategoryItem(
                        icon: Icons.sentiment_satisfied,
                        label: 'Fácil',
                        category: 'Quiz'),
                    CategoryItem(
                        icon: Icons.sentiment_neutral,
                        label: 'Medio',
                        category: 'Quiz'),
                    CategoryItem(
                        icon: Icons.sentiment_dissatisfied,
                        label: 'Difícil',
                        category: 'Quiz'),
                    CategoryItem(
                        icon: Icons.settings,
                        label: 'Ranking',
                        category: 'Quiz'),
                  ],
                ),
                SizedBox(height: 16),
                CategorySection(
                  title: 'Términos Pareados',
                  icon: Icons.compare_arrows,
                  items: [
                    CategoryItem(
                        icon: FontAwesomeIcons.smile,
                        label: 'Fácil',
                        category: 'TerminosPareados'),
                    CategoryItem(
                        icon: FontAwesomeIcons.meh,
                        label: 'Medio',
                        category: 'TerminosPareados'),
                    CategoryItem(
                        icon: FontAwesomeIcons.frown,
                        label: 'Difícil',
                        category: 'TerminosPareados'),
                    CategoryItem(
                        icon: Icons.settings,
                        label: 'Ranking',
                        category: 'TerminosPareados'),
                  ],
                ),
                SizedBox(height: 16),
                CategorySection(
                  title: 'Verdadero y Falso',
                  icon: Icons.list,
                  items: [
                    CategoryItem(
                        icon: Icons.sentiment_satisfied,
                        label: 'Fácil',
                        category: 'VerdaderoFalso'),
                    CategoryItem(
                        icon: Icons.sentiment_neutral,
                        label: 'Medio',
                        category: 'VerdaderoFalso'),
                    CategoryItem(
                        icon: Icons.sentiment_dissatisfied,
                        label: 'Difícil',
                        category: 'VerdaderoFalso'),
                    CategoryItem(
                        icon: Icons.settings,
                        label: 'Ranking',
                        category: 'VerdaderoFalso'),
                  ],
                ),
                SizedBox(height: 16),
                CategorySection(
                  title: 'Memorice',
                  icon: Icons.edit,
                  items: [
                    CategoryItem(
                        icon: Icons.sentiment_satisfied,
                        label: 'Fácil',
                        category: 'Memorice'),
                    CategoryItem(
                        icon: Icons.sentiment_neutral,
                        label: 'Medio',
                        category: 'Memorice'),
                    CategoryItem(
                        icon: Icons.sentiment_dissatisfied,
                        label: 'Difícil',
                        category: 'Memorice'),
                    CategoryItem(
                        icon: Icons.settings,
                        label: 'Ranking',
                        category: 'Memorice'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<CategoryItem> items;

  const CategorySection({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Icon(icon, color: Colors.purple, size: 30),
          title: Row(
            children: [
              SizedBox(width: 8), // Espacio entre el icono y el título
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.amber,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2E2E2E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16), // Añadir padding aquí
                children:
                    items.map((item) => CategoryIcon(item: item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final CategoryItem item;

  const CategoryIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Pantalla predeterminada para errores
        Widget targetScreen = Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text(
                'No se encontró la pantalla para esta categoría y dificultad'),
          ),
        );

        // Asignación de la pantalla según la categoría y la dificultad
        if (item.category == 'Quiz') {
          if (item.label == 'Fácil') {
            targetScreen = QuizFacilScreen();
          } else if (item.label == 'Medio') {
            targetScreen = QuizMedioScreen();
          } else if (item.label == 'Difícil') {
            targetScreen = QuizDificilScreen();
          }
        } else if (item.category == 'TerminosPareados') {
          if (item.label == 'Fácil') {
            // targetScreen = TerminosPareadosFacilScreen();
          } else if (item.label == 'Medio') {
            // targetScreen = TerminosPareadosMedioScreen();
          } else if (item.label == 'Difícil') {
            // targetScreen = TerminosPareadosDificilScreen();
          }
        } else if (item.category == 'VerdaderoFalso') {
          if (item.label == 'Fácil') {
            targetScreen = VerdaderoFalsoFacilScreen();
          } else if (item.label == 'Medio') {
            targetScreen = VerdaderoFalsoMedioScreen();
          } else if (item.label == 'Difícil') {
            targetScreen = VerdaderoFalsoDificilScreen();
          }
        } else if (item.category == 'Memorice') {
          if (item.label == 'Fácil') {
            // targetScreen = MemoriceFacilScreen();
          } else if (item.label == 'Medio') {
            // targetScreen = MemoriceMedioScreen();
          } else if (item.label == 'Difícil') {
            // targetScreen = MemoriceDificilScreen();
          }
        }

        // Navegación a la pantalla correspondiente
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => targetScreen,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: Icon(item.icon, color: Colors.purple, size: 30),
            ),
            SizedBox(height: 8),
            Text(
              item.label,
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDetailPage extends StatelessWidget {
  final String label;

  const CategoryDetailPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Center(
        child: Text('Contenido de la categoría $label'),
      ),
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String label;
  final String category;

  CategoryItem(
      {required this.icon, required this.label, required this.category});
}
