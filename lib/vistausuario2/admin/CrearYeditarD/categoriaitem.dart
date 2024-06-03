import 'package:astro_app/vistausuario2/admin/CrearYeditarD/iconos.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacildCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item: CategorydItem(icon: FontAwesomeIcons.add, label: 'Crear Memorice'),
    );
  }
}

class MediodCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorydIcon(
      item:
          CategorydItem(icon: FontAwesomeIcons.list, label: 'Editar Memorice'),
    );
  }
}
