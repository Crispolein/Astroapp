import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoriaPage(),
    );
  }
}

class CategoriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategorySection(
              title: 'Verdadero y Falso',
              icon: Icons.check_circle,
              items: [
                CategoryItem(icon: Icons.sentiment_satisfied, label: 'Fácil'),
                CategoryItem(icon: Icons.sentiment_neutral, label: 'Medio'),
                CategoryItem(
                    icon: Icons.sentiment_dissatisfied, label: 'Difícil'),
                CategoryItem(icon: Icons.settings, label: 'Personalizar'),
                CategoryItem(icon: Icons.star, label: 'Valorar'),
              ],
            ),
            SizedBox(height: 16),
            CategorySection(
              title: 'Términos Pareados',
              icon: Icons.compare_arrows,
              items: [
                CategoryItem(icon: FontAwesomeIcons.smile, label: 'Fácil'),
                CategoryItem(icon: FontAwesomeIcons.meh, label: 'Medio'),
                CategoryItem(icon: FontAwesomeIcons.frown, label: 'Difícil'),
                CategoryItem(icon: Icons.settings, label: 'Personalizar'),
                CategoryItem(icon: Icons.star, label: 'Valorar'),
              ],
            ),
            SizedBox(height: 16),
            CategorySection(
              title: 'Alternativas',
              icon: Icons.list,
              items: [
                CategoryItem(icon: Icons.sentiment_satisfied, label: 'Fácil'),
                CategoryItem(icon: Icons.sentiment_neutral, label: 'Medio'),
                CategoryItem(
                    icon: Icons.sentiment_dissatisfied, label: 'Difícil'),
                CategoryItem(icon: Icons.settings, label: 'Personalizar'),
                CategoryItem(icon: Icons.star, label: 'Valorar'),
              ],
            ),
            SizedBox(height: 16),
            CategorySection(
              title: 'Preguntas Abiertas',
              icon: Icons.edit,
              items: [
                CategoryItem(icon: Icons.sentiment_satisfied, label: 'Fácil'),
                CategoryItem(icon: Icons.sentiment_neutral, label: 'Medio'),
                CategoryItem(
                    icon: Icons.sentiment_dissatisfied, label: 'Difícil'),
                CategoryItem(icon: Icons.settings, label: 'Personalizar'),
                CategoryItem(icon: Icons.star, label: 'Valorar'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<CategoryItem> items;

  const CategorySection(
      {required this.title, required this.icon, required this.items});

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailPage(label: item.label),
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

  CategoryItem({required this.icon, required this.label});
}
