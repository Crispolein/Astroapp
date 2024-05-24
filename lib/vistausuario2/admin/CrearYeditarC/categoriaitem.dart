
import 'package:astro_app/vistausuario2/admin/CrearYeditarC/iconos.dart';
import 'package:flutter/material.dart';

class FacilcCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(
          icon: Icons.sentiment_satisfied,
          label: 'Fácil'), // Ítem de categoría fácil
    );
  }
}

class MediocCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(
          icon: Icons.sentiment_neutral,
          label: 'Medio'), // Ítem de categoría medio
    );
  }
}

class DificilcCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(
          icon: Icons.sentiment_dissatisfied,
          label: 'Difícil'), // Ítem de categoría difícil
    );
  }
}

class PersonalizarcCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(
          icon: Icons.settings, label: 'Personalizar'), // Ítem de personalizar
    );
  }
}

class ValorarcCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(icon: Icons.edit, label: 'Editar'), // Ítem de valorar
    );
  }
}