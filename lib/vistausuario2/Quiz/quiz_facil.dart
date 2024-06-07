import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración

class QuizFacilScreen extends StatefulWidget {
  @override
  _QuizFacilScreenState createState() => _QuizFacilScreenState();
}

class _QuizFacilScreenState extends State<QuizFacilScreen> {
  List<Quiz> _quizzes = [];
  int _currentIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    FirebaseFirestore.instance
        .collection('quizzes')
        .where('dificultad', isEqualTo: 'Facil')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _quizzes = querySnapshot.docs
            .map((doc) => Quiz.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
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

  void _checkAnswer(String selectedAnswer) {
    setState(() {
      _isAnswered = true;
      _isCorrect = selectedAnswer == _quizzes[_currentIndex].respuestaCorrecta;
    });

    if (_isCorrect) {
      _vibrateOnCorrect(); // Vibración para acierto
    } else {
      _vibrateOnIncorrect(); // Vibración para error
    }

    Timer(Duration(seconds: 2), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _quizzes.length;
        _isAnswered = false;
      });
    });
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
    List<String> answers = [
      currentQuiz.respuesta,
      currentQuiz.respuesta2,
      currentQuiz.respuesta3,
      currentQuiz.respuesta4,
    ];
    answers.shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Fácil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (currentQuiz.imagenURL != null)
              Expanded(
                flex: 1,
                child: Image.network(currentQuiz.imagenURL!),
              ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    currentQuiz.pregunta,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: answers.map((answer) {
                      return ElevatedButton(
                        onPressed:
                            _isAnswered ? null : () => _checkAnswer(answer),
                        child: Text(answer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAnswered
                              ? answer == currentQuiz.respuestaCorrecta
                                  ? Colors.green
                                  : Colors.red
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  if (_isAnswered)
                    Text(
                      _isCorrect ? '¡Correcto!' : 'Incorrecto',
                      style: TextStyle(
                        color: _isCorrect ? Colors.green : Colors.red,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
