import 'package:astro_app/vistausuario2/admin/CrearYeditarC/iconos.dart';
import 'package:flutter/material.dart';

class FacilcCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(
          icon: Icons.sentiment_satisfied, label: 'Crear Terminos'),
    );
  }
}

class MediocCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(
          icon: Icons.sentiment_neutral, label: 'Listar terminos'),
    );
  }
}
