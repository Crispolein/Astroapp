import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class MemoriceGameScreen extends StatefulWidget {
  final int numImages;
  final String difficulty;

  MemoriceGameScreen({required this.numImages, required this.difficulty});

  @override
  _MemoriceGameScreenState createState() => _MemoriceGameScreenState();
}

class _MemoriceGameScreenState extends State<MemoriceGameScreen> {
  List<Map<String, dynamic>> _imagePairs = [];
  List<Map<String, dynamic>> _shuffledImagePairs = [];
  List<bool> _revealed = [];
  int? _selectedIndex;
  bool _canTap = true;
  late Timer _timer;
  int _timeElapsed = 0;
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadImages() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('memoryImages').get();

    List<Map<String, dynamic>> allImages = snapshot.docs
        .map((doc) => {'id': doc.id, 'imageUrl': doc['imageUrl']})
        .toList();

    allImages.shuffle();
    List<Map<String, dynamic>> selectedImages =
        allImages.take(widget.numImages).toList();

    _imagePairs = selectedImages + selectedImages;
    _imagePairs.shuffle();

    setState(() {
      _shuffledImagePairs = _imagePairs;
      _revealed = List<bool>.filled(_shuffledImagePairs.length, true);
    });

    // Mostrar las imágenes por 2 segundos al inicio del juego
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _revealed = List<bool>.filled(_shuffledImagePairs.length, false);
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
    });
  }

  void _vibrateOnCorrect() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(pattern: [0, 100, 50, 100]); // Patrón para acierto
    }
  }

  void _vibrateOnIncorrect() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(pattern: [0, 200, 50, 200]); // Patrón para error
    }
  }

  void _vibrateOnTap() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(duration: 50); // Vibración al tocar la tarjeta
    }
  }

  void _onCardTapped(int index) {
    if (_canTap && !_revealed[index]) {
      _vibrateOnTap(); // Activar vibración al tocar la tarjeta
      setState(() {
        _revealed[index] = true;
      });

      if (_selectedIndex == null) {
        _selectedIndex = index;
      } else {
        if (_shuffledImagePairs[_selectedIndex!]['id'] ==
            _shuffledImagePairs[index]['id']) {
          _vibrateOnCorrect(); // Vibración para acierto
          _selectedIndex = null;
          _checkGameCompleted();
        } else {
          _vibrateOnIncorrect(); // Vibración para error
          _canTap = false;
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _revealed[_selectedIndex!] = false;
              _revealed[index] = false;
              _selectedIndex = null;
              _canTap = true;
            });
          });
        }
      }
    }
  }

  void _checkGameCompleted() {
    if (_revealed.every((element) => element)) {
      _gameCompleted = true;
      _timer.cancel();
      _calculateAndSaveScore();
    }
  }

  void _calculateAndSaveScore() async {
    int baseScore;
    switch (widget.difficulty) {
      case 'facil':
        baseScore = 100;
        break;
      case 'medio':
        baseScore = 200;
        break;
      case 'dificil':
        baseScore = 300;
        break;
      default:
        baseScore = 100;
    }

    int score = baseScore - _timeElapsed;
    if (score < 0) score = 0;

    String username = await _getCurrentUsername();

    await FirebaseFirestore.instance.collection('rankings').add({
      'username': username,
      'score': score,
      'game': 'memorice',
      'level': widget.difficulty,
      'timeElapsed': _timeElapsed,
    });

    _showGameCompletedDialog(score);
  }

  Future<String> _getCurrentUsername() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      debugPrint("ID del usuario autenticado: $userId");

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        debugPrint("Documento del usuario encontrado: ${userSnapshot.data()}");
        return userSnapshot['username'];
      } else {
        // Manejo mejorado de errores
        debugPrint(
            "El documento del usuario con ID $userId no existe en la colección 'usuarios'.");
        throw StateError("El documento del usuario no existe");
      }
    } else {
      // Manejo mejorado de errores
      debugPrint("No hay usuario autenticado.");
      throw StateError("No hay usuario autenticado");
    }
  }

  void _showGameCompletedDialog(int score) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Juego completado!'),
        content: Text('Puntuación: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_shuffledImagePairs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Memorice'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Memorice'),
      ),
      body: Column(
        children: [
          Text('Tiempo: $_timeElapsed s'),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: _shuffledImagePairs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onCardTapped(index),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[300],
                    ),
                    child: _revealed[index]
                        ? Image.network(
                            _shuffledImagePairs[index]['imageUrl'],
                            fit: BoxFit.cover,
                          )
                        : Center(child: Icon(Icons.image, size: 50)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
