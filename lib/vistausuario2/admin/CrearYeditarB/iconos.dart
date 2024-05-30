import 'package:astro_app/vistausuario2/admin/CrearYeditarB/editartruefalse.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarB/listartruefalse.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarB/crearquiz.dart';
import 'package:flutter/material.dart';

class CategorybIcon extends StatelessWidget {
  final CategorybItem item; // Ítem de categoría

  const CategorybIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página correspondiente según la etiqueta del ítem
        Widget destination;
        switch (item.label) {
          case 'Crear Preguntas':
            destination = CrearTrueFalsePage(); // Página de creación de quiz
            break;
          case 'Listar Preguntas':
            destination = ListarTrueFalsePage(); // Página de listado de quiz
            break;
          default:
            destination = ListarTrueFalsePage(); // Página por defecto
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

class CategorybItem {
  final IconData icon; // Icono del ítem
  final String label; // Etiqueta del ítem

  CategorybItem({required this.icon, required this.label});
}
