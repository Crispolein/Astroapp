import 'package:astro_app/vistausuario2/admin/CrearYeditarD/EditarQuiz.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarD/crearquiz.dart';
import 'package:flutter/material.dart';

class CategorydIcon extends StatelessWidget {
  final CategorydItem item; // Ítem de categoría

  const CategorydIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página correspondiente según la etiqueta del ítem
        Widget destination;
        switch (item.label) {
          case 'Crear Memorice':
            destination = CrearImagenesPage(); // Página de creación de quiz
          case 'Editar Memorice':
            destination = EditardQuizPage(); // Página de valoración de quiz

          default:
            destination = EditardQuizPage(); // Página por defecto
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

class CategorydItem {
  final IconData icon; // Icono del ítem
  final String label; // Etiqueta del ítem

  CategorydItem({required this.icon, required this.label});
}
