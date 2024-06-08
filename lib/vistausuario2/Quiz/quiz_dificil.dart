import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para obtener el usuario actual

class QuizDificilScreen extends StatefulWidget {
  @override
  _QuizDificilScreenState createState() => _QuizDificilScreenState();
}

class _QuizDificilScreenState extends State<QuizDificilScreen> {
  List<Quiz> _quizzes = [];
  List<List<String>> _shuffledAnswers = [];
  int _currentIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  int _score = 0;
  int _streak = 0;
  int _timeLeft = 10; // Tiempo por pregunta en segundos
  late Timer _timer;

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
    _currentUser =
        FirebaseAuth.instance.currentUser; // Obtener el usuario actual
  }

  Future<void> _fetchQuizzes() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('dificultad', isEqualTo: 'Dificil')
          .get();

      List<Quiz> quizzes = querySnapshot.docs
          .map((doc) => Quiz.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      if (quizzes.isEmpty) {
        _showNoQuizzesDialog();
      } else {
        setState(() {
          _quizzes = quizzes.take(5).toList(); // Tomar hasta 5 preguntas
          // Shuffle answers for each quiz and store in _shuffledAnswers
          _shuffledAnswers = _quizzes.map((quiz) {
            List<String> answers = [
              quiz.respuesta,
              quiz.respuesta2,
              quiz.respuesta3,
              quiz.respuesta4
            ];
            answers.shuffle();
            return answers;
          }).toList();
          _startTimer();
        });
      }
    } catch (e) {
      print('Error al obtener los quizzes: $e');
      _showErrorDialog(e.toString());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _checkAnswer(null);
        }
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

  void _checkAnswer(String? selectedAnswer) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _isCorrect = selectedAnswer == _quizzes[_currentIndex].respuestaCorrecta;

      if (_isCorrect) {
        _score += 300 + (_streak * 10); // Base score + streak bonus
        _streak++;
        _vibrateOnCorrect(); // Vibración para acierto
      } else {
        _streak = 0;
        _vibrateOnIncorrect(); // Vibración para error
      }

      _timer.cancel();
    });

    Timer(Duration(seconds: 2), () {
      if (_currentIndex + 1 < _quizzes.length) {
        setState(() {
          _currentIndex++;
          _isAnswered = false;
          _timeLeft = 10;
          _startTimer();
        });
      } else {
        _recordScore();
        _showGameOverDialog();
      }
    });
  }

  Future<void> _recordScore() async {
    if (_currentUser != null) {
      final ranking = Ranking(
        id: FirebaseFirestore.instance.collection('rankings').doc().id,
        userId: _currentUser!.uid,
        score: _score,
        game: 'Quiz', // Puedes cambiarlo según el tipo de juego
        level: 'Dificil', // Cambiar según el nivel de dificultad actual
      );

      await FirebaseFirestore.instance
          .collection('rankings')
          .doc(ranking.id)
          .set(ranking.toMap());
    }
  }

  void _showNoQuizzesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No hay quizzes disponibles'),
        content:
            Text('No se encontraron quizzes con la dificultad especificada.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Regresar a la pantalla anterior
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Regresar a la pantalla anterior
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

 void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.teal),
            SizedBox(width: 10),
            Text('¡Juego Terminado!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Has respondido todas las preguntas.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Puntuación final: $_score puntos.',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Volver a la pantalla anterior
              },
              child: Text('Aceptar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_quizzes.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Quiz currentQuiz = _quizzes[_currentIndex];
    List<String> answers = _shuffledAnswers[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title:
            Text('               Racha: $_streak', textAlign: TextAlign.center),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centrar contenido horizontalmente
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tiempo restante: $_timeLeft',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'Puntuación: $_score',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              if (currentQuiz.imagenURL != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(currentQuiz.imagenURL!),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                currentQuiz.pregunta,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.7, // Ajuste de aspecto para encoger botones
                children: answers.map((answer) {
                  return ElevatedButton(
                    onPressed: _isAnswered ? null : () => _checkAnswer(answer),
                    child: Text(
                      answer,
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white), // Tamaño de texto reducido
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswered
                          ? answer == currentQuiz.respuestaCorrecta
                              ? Colors.green
                              : Colors.red
                          : Colors.teal,
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0), // Padding reducido
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_isAnswered)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    _isCorrect ? '¡Correcto!' : 'Incorrecto',
                    style: TextStyle(
                      color: _isCorrect ? Colors.green : Colors.red,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
