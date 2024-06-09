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

class _MemoriceGameScreenState extends State<MemoriceGameScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _imagePairs = [];
  List<Map<String, dynamic>> _shuffledImagePairs = [];
  List<bool> _revealed = [];
  int? _selectedIndex;
  bool _canTap = true;
  late Timer _timer;
  int _timeElapsed = 0;
  bool _gameCompleted = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadImages();
    _startTimer();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
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
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 40),
            SizedBox(width: 10),
            Text(
              '¡Juego completado!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        content: Text(
          'Puntuación: $score',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(fontSize: 18, color: Colors.teal),
            ),
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
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tiempo: $_timeElapsed s',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                ),
                itemCount: _shuffledImagePairs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTapped(index),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return RotationYTransition(
                          turns: animation,
                          child: child,
                        );
                      },
                      child: _revealed[index]
                          ? Container(
                              key: ValueKey(true),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.grey[300],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                  _shuffledImagePairs[index]['imageUrl'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            )
                          : Container(
                              key: ValueKey(false),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.teal,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child;
  final Animation<double> turns;

  RotationYTransition({required this.turns, required this.child})
      : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final angle = turns.value * 3.1415926535897932;
    final transform = Matrix4.rotationY(angle);

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: child,
    );
  }
}
