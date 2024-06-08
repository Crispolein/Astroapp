import 'dart:async';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración
import 'package:firebase_auth/firebase_auth.dart'; // Para obtener el usuario actual

class VerdaderoFalsoFacilScreen extends StatefulWidget {
  @override
  _VerdaderoFalsoFacilScreenState createState() =>
      _VerdaderoFalsoFacilScreenState();
}

class _VerdaderoFalsoFacilScreenState extends State<VerdaderoFalsoFacilScreen> {
  List<TrueFalseQuestion> _questions = [];
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
    _fetchQuestions();
    _currentUser =
        FirebaseAuth.instance.currentUser; // Obtener el usuario actual
  }

  Future<void> _fetchQuestions() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('truefalse')
          .where('dificultad', isEqualTo: 'Facil')
          .get();

      List<TrueFalseQuestion> questions = querySnapshot.docs
          .map((doc) =>
              TrueFalseQuestion.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      if (questions.isEmpty) {
        _showNoQuestionsDialog();
      } else {
        setState(() {
          _questions = questions.take(5).toList(); // Tomar hasta 5 preguntas
          _startTimer();
        });
      }
    } catch (e) {
      print('Error al obtener las preguntas: $e');
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

  void _checkAnswer(bool? selectedAnswer) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _isCorrect =
          selectedAnswer == _questions[_currentIndex].respuestaCorrecta;

      if (_isCorrect) {
        _score += 100 + (_streak * 10); // Base score + streak bonus
        _streak++;
        _vibrateOnCorrect(); // Vibración para acierto
      } else {
        _streak = 0;
        _vibrateOnIncorrect(); // Vibración para error
      }

      _timer.cancel();
    });

    Timer(Duration(seconds: 2), () {
      if (_currentIndex + 1 < _questions.length) {
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
        game: 'TrueFalse', // Puedes cambiarlo según el tipo de juego
        level: 'Facil', // Cambiar según el nivel de dificultad actual
      );

      await FirebaseFirestore.instance
          .collection('rankings')
          .doc(ranking.id)
          .set(ranking.toMap());
    }
  }

  void _showNoQuestionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No hay preguntas disponibles'),
        content:
            Text('No se encontraron preguntas con la dificultad especificada.'),
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
        title: Text('Fin del juego'),
        content: Text(
            'Has respondido todas las preguntas. Puntuación final: $_score'),
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

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    TrueFalseQuestion currentQuestion = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Verdadero o Falso - Fácil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (currentQuestion.imagenURL != null)
                Image.network(currentQuestion.imagenURL!),
              SizedBox(height: 20),
              Text(
                currentQuestion.pregunta,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _isAnswered ? null : () => _checkAnswer(true),
                    child: Text('Verdadero'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswered
                          ? currentQuestion.respuestaCorrecta
                              ? Colors.green
                              : Colors.red
                          : null,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isAnswered ? null : () => _checkAnswer(false),
                    child: Text('Falso'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswered
                          ? !currentQuestion.respuestaCorrecta
                              ? Colors.green
                              : Colors.red
                          : null,
                    ),
                  ),
                ],
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
              Text(
                'Tiempo restante: $_timeLeft',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Puntuación: $_score',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Racha: $_streak',
                style: TextStyle(fontSize: 20.0),
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
