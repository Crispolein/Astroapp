import 'package:astro_app/vistausuario2/admin/CrearYeditarD/iconos.dart';
import 'package:flutter/material.dart';

class FacildCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item: CategorydItem(
          icon: Icons.sentiment_satisfied,
          label: 'Fácil'), // Ítem de categoría fácil
    );
  }
}

class MediodCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item: CategorydItem(
          icon: Icons.sentiment_neutral,
          label: 'Medio'), // Ítem de categoría medio
    );
  }
}

class DificildCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item: CategorydItem(
          icon: Icons.sentiment_dissatisfied,
          label: 'Difícil'), // Ítem de categoría difícil
    );
  }
}

class PersonalizardCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item: CategorydItem(
          icon: Icons.settings, label: 'Personalizar'), // Ítem de personalizar
    );
  }
}

class ValorardCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item: CategorydItem(icon: Icons.edit, label: 'Editar'), // Ítem de valorar
    );
  }
}
