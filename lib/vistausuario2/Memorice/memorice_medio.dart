import 'package:astro_app/vistausuario2/Memorice/memorice_game.dart';
import 'package:flutter/material.dart';

class MemoriceMedioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MemoriceGameScreen(numImages: 6, difficulty: 'medio');
  }
}
