import 'package:astro_app/vistausuario2/Memorice/memorice_dificl.dart';
import 'package:astro_app/vistausuario2/Quiz/quiz_dificil.dart';
import 'package:astro_app/vistausuario2/Quiz/quiz_facil.dart';
import 'package:astro_app/vistausuario2/Quiz/quiz_medio.dart';
import 'package:astro_app/vistausuario2/TerminosPareados/categorias.dart';
import 'package:astro_app/vistausuario2/VerdaderoFalso/verdadero_falso_dificil.dart';
import 'package:astro_app/vistausuario2/VerdaderoFalso/verdadero_falso_facil.dart';
import 'package:astro_app/vistausuario2/VerdaderoFalso/verdadero_falso_medio.dart';
import 'package:astro_app/vistausuario2/admin/theme.dart';
import 'package:flutter/material.dart';
import 'package:astro_app/vistausuario2/Memorice/memorice_facil.dart';
import 'package:astro_app/vistausuario2/Memorice/memorice_medio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración

class CategoriaPage extends StatefulWidget {
  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  void _toggleTheme() {
    setState(() {
      themeNotifier.toggleTheme();
    });
  }

  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(
          duration: 50); // Duración de la vibración en milisegundos
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF2C2C2E)
            : Color.fromARGB(255, 255, 255, 255);
    final Color titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.amber
        : Colors.black;
    final Color iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.amber
        : Colors.black;
    final Color containerOuterColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF2C2C2E)
            : Color(0xFFFFFFFF);
    final Color containerInnerColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF3C3C3E)
            : Color(0xFFF0F0F0);
    final Color buttonOuterColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF3C3C3E)
            : Color(0xFFE0E0E0);
    final Color buttonInnerColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.purple
            : Color(0xFFFFFFFF);
    final Color shadowColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(177, 255, 22, 22)
        : Colors.black26;
    final Color appBarColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2C2C2E)
        : Colors.purple;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Container(
        key: ValueKey<ThemeMode>(themeNotifier.value),
        color: backgroundColor,
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: GestureDetector(
                onTap: _toggleTheme,
                child: Text(
                  'Juegos',
                  style: TextStyle(
                      fontSize: 30,
                      color: titleColor), // Tamaño y color del título
                ),
              ),
            ),
            backgroundColor: appBarColor,
            automaticallyImplyLeading: false, // Quita la flecha de regreso
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategorySection(
                      title: 'Quiz',
                      icon: Icons.check_circle,
                      items: [
                        CategoryItem(
                            icon: FontAwesomeIcons.faceSmile,
                            label: 'Fácil',
                            category: 'Quiz'),
                        CategoryItem(
                            icon: FontAwesomeIcons.faceMeh,
                            label: 'Medio',
                            category: 'Quiz'),
                        CategoryItem(
                            icon: FontAwesomeIcons.faceFrown,
                            label: 'Difícil',
                            category: 'Quiz'),
                        CategoryItem(
                            icon: Icons.settings,
                            label: 'Ranking',
                            category: 'Quiz'),
                      ],
                      iconColor: iconColor,
                      containerOuterColor: containerOuterColor,
                      containerInnerColor: containerInnerColor,
                      buttonOuterColor: buttonOuterColor,
                      buttonInnerColor: buttonInnerColor,
                      shadowColor: shadowColor,
                    ),
                    SizedBox(height: 16),
                    CategorySection(
                      title: 'Términos Pareados',
                      icon: Icons.compare_arrows,
                      items: [
                        CategoryItem(
                            icon: Icons.play_arrow,
                            label: 'Jugar',
                            category: 'TerminosPareados'),
                        CategoryItem(
                            icon: Icons.settings,
                            label: 'Ranking',
                            category: 'TerminosPareados'),
                      ],
                      iconColor: iconColor,
                      containerOuterColor: containerOuterColor,
                      containerInnerColor: containerInnerColor,
                      buttonOuterColor: buttonOuterColor,
                      buttonInnerColor: buttonInnerColor,
                      shadowColor: shadowColor,
                    ),
                    SizedBox(height: 16),
                    CategorySection(
                      title: 'Verdadero y Falso',
                      icon: Icons.list,
                      items: [
                        CategoryItem(
                            icon: FontAwesomeIcons.faceSmile,
                            label: 'Fácil',
                            category: 'VerdaderoFalso'),
                        CategoryItem(
                            icon: FontAwesomeIcons.faceMeh,
                            label: 'Medio',
                            category: 'VerdaderoFalso'),
                        CategoryItem(
                            icon: FontAwesomeIcons.faceFrown,
                            label: 'Difícil',
                            category: 'VerdaderoFalso'),
                        CategoryItem(
                            icon: Icons.settings,
                            label: 'Ranking',
                            category: 'VerdaderoFalso'),
                      ],
                      iconColor: iconColor,
                      containerOuterColor: containerOuterColor,
                      containerInnerColor: containerInnerColor,
                      buttonOuterColor: buttonOuterColor,
                      buttonInnerColor: buttonInnerColor,
                      shadowColor: shadowColor,
                    ),
                    SizedBox(height: 16),
                    CategorySection(
                      title: 'Memorice',
                      icon: Icons.edit,
                      items: [
                        CategoryItem(
                            icon: FontAwesomeIcons.faceSmile,
                            label: 'Fácil',
                            category: 'Memorice'),
                        CategoryItem(
                            icon: FontAwesomeIcons.faceMeh,
                            label: 'Medio',
                            category: 'Memorice'),
                        CategoryItem(
                            icon: FontAwesomeIcons.faceFrown,
                            label: 'Difícil',
                            category: 'Memorice'),
                        CategoryItem(
                            icon: Icons.settings,
                            label: 'Ranking',
                            category: 'Memorice'),
                      ],
                      iconColor: iconColor,
                      containerOuterColor: containerOuterColor,
                      containerInnerColor: containerInnerColor,
                      buttonOuterColor: buttonOuterColor,
                      buttonInnerColor: buttonInnerColor,
                      shadowColor: shadowColor,
                    ),
                  ],
                ),
              ),
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
  final Color iconColor;
  final Color containerOuterColor;
  final Color containerInnerColor;
  final Color buttonOuterColor;
  final Color buttonInnerColor;
  final Color shadowColor;

  const CategorySection({
    required this.title,
    required this.icon,
    required this.items,
    required this.iconColor,
    required this.containerOuterColor,
    required this.containerInnerColor,
    required this.buttonOuterColor,
    required this.buttonInnerColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containerOuterColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10.0,
            spreadRadius: 1.9,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Icon(icon, color: iconColor, size: 30),
          title: Row(
            children: [
              SizedBox(width: 8), // Espacio entre el icono y el título
              Text(
                title,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          backgroundColor: containerOuterColor,
          children: [
            Container(
              decoration: BoxDecoration(
                color: containerInnerColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: GridView.count(
                crossAxisCount: 2, // Cambiado a 2 para que haya dos botones
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0), // Ajuste de padding
                children: items
                    .map((item) => CategoryIcon(
                        item: item,
                        iconColor: iconColor,
                        outerColor: buttonOuterColor,
                        innerColor: buttonInnerColor,
                        shadowColor: shadowColor))
                    .toList(),
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
  final Color iconColor;
  final Color outerColor;
  final Color innerColor;
  final Color shadowColor;

  const CategoryIcon({
    required this.item,
    required this.iconColor,
    required this.outerColor,
    required this.innerColor,
    required this.shadowColor,
  });

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
          if (item.label == 'Jugar') {
            targetScreen =
                CategoriaSeleccionScreen(); // Nueva pantalla del juego de términos pareados
          } else if (item.label == 'Ranking') {
            targetScreen =
                CategoryDetailPage(label: 'Ranking de Términos Pareados');
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
            targetScreen = MemoriceFacilScreen();
          } else if (item.label == 'Medio') {
            targetScreen = MemoriceMedioScreen();
          } else if (item.label == 'Difícil') {
            targetScreen = MemoriceDificilScreen();
          }
        }

        // Navegación a la pantalla correspondiente
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => targetScreen,
          ),
        );
        Vibration.vibrate(duration: 50); // Activar vibración al tocar el botón
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: outerColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 10.0,
                    spreadRadius: 1.9,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: innerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
                child: Icon(item.icon, color: iconColor, size: 30),
              ),
            ),
            SizedBox(height: 8),
            Text(
              item.label,
              style: TextStyle(color: iconColor, fontSize: 14),
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
