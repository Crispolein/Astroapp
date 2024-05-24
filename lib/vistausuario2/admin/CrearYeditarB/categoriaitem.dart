
import 'package:astro_app/vistausuario2/admin/CrearYeditarB/iconos.dart';
import 'package:flutter/material.dart';

class FacilbCategoryItem extends StatelessWidget {
  const FacilbCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(
          icon: Icons.sentiment_satisfied,
          label: 'Fácil'), // Ítem de categoría fácil
    );
  }
}

class MediobCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(
          icon: Icons.sentiment_neutral,
          label: 'Medio'), // Ítem de categoría medio
    );
  }
}

class DificilbCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(
          icon: Icons.sentiment_dissatisfied,
          label: 'Difícil'), // Ítem de categoría difícil
    );
  }
}

class PersonalizarbCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(
          icon: Icons.settings, label: 'Personalizar'), // Ítem de personalizar
    );
  }
}

class ValorarbCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(icon: Icons.edit, label: 'Editar'), // Ítem de valorar
    );
  }
}
