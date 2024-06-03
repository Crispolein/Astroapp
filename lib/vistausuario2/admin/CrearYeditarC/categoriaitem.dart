import 'package:astro_app/vistausuario2/admin/CrearYeditarC/iconos.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacilcCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(
          icon: FontAwesomeIcons.add, label: 'Crear Terminos'),
    );
  }
}

class MediocCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorycIcon(
      item: CategorycItem(
          icon: FontAwesomeIcons.list, label: 'Listar terminos'),
    );
  }
}
