import 'package:astro_app/vistausuario2/admin/CrearYeditarB/iconos.dart';
import 'package:flutter/material.dart';

class FacilbCategoryItem extends StatelessWidget {
  const FacilbCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(
          icon: Icons.sentiment_satisfied,
          label: 'Crear Preguntas'), // Ítem de categoría fácil
    );
  }
}

class MediobCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(
          icon: Icons.sentiment_neutral,
          label: 'Listar Preguntas'), // Ítem de categoría medio
    );
  }
}
