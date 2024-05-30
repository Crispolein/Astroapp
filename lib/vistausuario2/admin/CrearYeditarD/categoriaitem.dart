import 'package:astro_app/vistausuario2/admin/CrearYeditarD/iconos.dart';
import 'package:flutter/material.dart';

class FacildCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item: CategorydItem(
          icon: Icons.sentiment_satisfied, label: 'Crear Memorice'),
    );
  }
}

class MediodCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item: CategorydItem(
          icon: Icons.sentiment_neutral, label: 'Editar Memorice'),
    );
  }
}
