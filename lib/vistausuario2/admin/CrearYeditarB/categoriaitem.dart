import 'package:astro_app/vistausuario2/admin/CrearYeditarB/iconos.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacilbCategoryItem extends StatelessWidget {
  const FacilbCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(
          icon: FontAwesomeIcons.add,
          label: 'Crear Preguntas'), // Ítem de categoría fácil
    );
  }
}

class MediobCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategorybIcon(
      item: CategorybItem(
          icon: FontAwesomeIcons.list,
          label: 'Listar Preguntas'), // Ítem de categoría medio
    );
  }
}
