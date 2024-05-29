import 'package:astro_app/vistausuario2/admin/CrearYeditarA/crearquiz.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarA/personalizarquiz.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarA/EditarQuiz.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarB/categoriaitem.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarC/categoriaitem.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarD/categoriaitem.dart';
import 'package:astro_app/vistausuario2/admin/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // Inicia la aplicación y llama a MyApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoriaadminPage(), // Define la página de inicio de la aplicación
    );
  }
}

class CategoriaadminPage extends StatefulWidget {
  @override
  _CategoriaadminPageState createState() => _CategoriaadminPageState();
}

class _CategoriaadminPageState extends State<CategoriaadminPage> {
  void _toggleTheme() {
    setState(() {
      themeNotifier.toggleTheme();
    });
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

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Container(
        key: ValueKey<ThemeMode>(themeNotifier.value),
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Padding alrededor del contenido
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título llamativo
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0,
                        bottom:
                            16.0), // Ajusta el valor de 'top' para bajar el título
                    child: Text(
                      'Categorías de Juegos', // Texto del título
                      style: TextStyle(
                        color: titleColor, // Color del texto del título
                        fontSize: 32, // Tamaño de fuente
                        fontWeight: FontWeight.bold, // Grosor de la fuente
                        letterSpacing: 1.5, // Espaciado entre letras
                        shadows: [
                          Shadow(
                            offset:
                                Offset(2.0, 2.0), // Desplazamiento de la sombra
                            blurRadius: 3.0, // Radio de desenfoque de la sombra
                            color: Colors.black
                                .withOpacity(0.5), // Color de la sombra
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Secciones de categorías
                  CategorySection(
                    title: 'Alternativas', // Título de la sección
                    icon: Icons.list, // Icono de la sección
                    items: [
                      FacilCategoryItem(), // Botón de categoría fácil
                      MedioCategoryItem(), // Botón de categoría medio
                      DificilCategoryItem(), // Botón de categoría difícil
                      PersonalizarCategoryItem(), // Botón de personalizar
                      ValorarCategoryItem(), // Botón de valorar
                    ],
                  ),
                  SizedBox(height: 16), // Espacio entre secciones
                  CategorySection(
                    title: 'Verdadero Y Falso',
                    icon: Icons.check_circle,
                    items: [
                      FacilbCategoryItem(),
                      MediobCategoryItem(),
                      DificilbCategoryItem(),
                      PersonalizarbCategoryItem(),
                      ValorarbCategoryItem(),
                    ],
                  ),
                  SizedBox(height: 16),
                  CategorySection(
                    title: 'Terminos Pareados',
                    icon: Icons.compare_arrows,
                    items: [
                      FacilcCategoryItem(),
                      MediocCategoryItem(),
                      DificilcCategoryItem(),
                      PersonalizarcCategoryItem(),
                      ValorarcCategoryItem(),
                    ],
                  ),
                  SizedBox(height: 16),
                  CategorySection(
                    title: 'Preguntas Abiertas',
                    icon: Icons.edit,
                    items: [
                      FacildCategoryItem(),
                      MediodCategoryItem(),
                      DificildCategoryItem(),
                      PersonalizardCategoryItem(),
                      ValorardCategoryItem(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title; // Título de la sección
  final IconData icon; // Icono de la sección
  final List<Widget> items; // Lista de ítems de la sección

  const CategorySection(
      {required this.title, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber, // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Bordes redondeados del clip
        child: ExpansionTile(
          initiallyExpanded: false, // Expansión inicial de la tile
          tilePadding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Padding de la tile
          leading: Icon(icon,
              color: Colors.purple, size: 30), // Icono principal de la tile
          title: Row(
            children: [
              SizedBox(width: 8), // Espacio entre el icono y el título
              Text(
                title, // Texto del título
                style: TextStyle(
                  color: Colors.black, // Color del texto
                  fontWeight: FontWeight.bold, // Grosor del texto
                  fontSize: 18, // Tamaño del texto
                ),
              ),
            ],
          ),
          backgroundColor: Colors.amber, // Color de fondo de la tile
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    Color(0xFF2E2E2E), // Color de fondo del contenedor interno
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(10), // Bordes redondeados inferiores
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: GridView.count(
                crossAxisCount: 3, // Número de columnas en la cuadrícula
                shrinkWrap: true, // Ajustar al contenido
                physics:
                    NeverScrollableScrollPhysics(), // Deshabilitar el scroll
                padding: const EdgeInsets.all(
                    16), // Padding alrededor de la cuadrícula
                children: items, // Ítems de la cuadrícula
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacilCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryIcon(
      item: CategoryItem(
          icon: Icons.sentiment_satisfied,
          label: 'Crear Quiz'), // Ítem de categoría fácil
    );
  }
}

class MedioCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryIcon(
      item: CategoryItem(
          icon: Icons.sentiment_neutral,
          label: 'Listar Quiz'), // Ítem de categoría medio
    );
  }
}

class DificilCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryIcon(
      item: CategoryItem(
          icon: Icons.sentiment_dissatisfied,
          label: 'Difícil'), // Ítem de categoría difícil
    );
  }
}

class PersonalizarCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryIcon(
      item: CategoryItem(
          icon: Icons.settings, label: 'Personalizar'), // Ítem de personalizar
    );
  }
}

class ValorarCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryIcon(
      item: CategoryItem(icon: Icons.edit, label: 'Editar'), // Ítem de valorar
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final CategoryItem item; // Ítem de categoría

  const CategoryIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página correspondiente según la etiqueta del ítem
        Widget destination;
        switch (item.label) {
          case 'Fácil':
          case 'Medio':
          case 'Difícil':
            destination = CrearQuizPage(); // Página de creación de quiz
            break;
          case 'Personalizar':
            destination =
                PersonalizarQuizPage(); // Página de personalización de quiz
            break;
          case 'Editar':
            destination = ListarQuizPage(); // Página de valoración de quiz
            break;
          default:
            destination = ListarQuizPage(); // Página por defecto
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destination, // Ruta a la página de destino
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Padding alrededor del ítem
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo del icono
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              padding: EdgeInsets.all(16), // Padding dentro del contenedor
              child: Icon(item.icon,
                  color: Colors.purple, size: 30), // Icono del ítem
            ),
            SizedBox(height: 8), // Espacio entre el icono y el texto
            Text(
              item.label, // Texto del ítem
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final IconData icon; // Icono del ítem
  final String label; // Etiqueta del ítem

  CategoryItem({required this.icon, required this.label});
}
