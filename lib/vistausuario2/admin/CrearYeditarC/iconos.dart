import 'package:astro_app/vistausuario2/admin/CrearYeditarC/EditarQuiz.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarC/crearquiz.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarC/personalizarquiz.dart';
import 'package:flutter/material.dart';

class CategorycIcon extends StatelessWidget {
  final CategorycItem item; // Ítem de categoría

  const CategorycIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página correspondiente según la etiqueta del ítem
        Widget destination;
        switch (item.label) {
          case 'Crear Terminos':
            destination = CrearcQuizPage();
          case 'Listar Terminos':
            destination = EditarcQuizPage();
          default:
            destination = EditarcQuizPage(); // Página por defecto
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destination, // Ruta a la página de destino
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(28.0), // Padding alrededor del ítem
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo del icono
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
              padding: EdgeInsets.all(18), // Padding dentro del contenedor
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

class CategorycItem {
  final IconData icon; // Icono del ítem
  final String label; // Etiqueta del ítem

  CategorycItem({required this.icon, required this.label});
}
