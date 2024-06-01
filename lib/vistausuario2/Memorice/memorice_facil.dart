import 'package:astro_app/vistausuario2/Memorice/memorice_game.dart';
import 'package:flutter/material.dart';

class MemoriceFacilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MemoriceGameScreen(numImages: 3, difficulty: 'facil');
  }
}
