import 'dart:async';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para obtener el usuario actual

class VerdaderoFalsoMedioScreen extends StatefulWidget {
  @override
  _VerdaderoFalsoMedioScreenState createState() =>
      _VerdaderoFalsoMedioScreenState();
}

class _VerdaderoFalsoMedioScreenState extends State<VerdaderoFalsoMedioScreen> {
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
          .where('dificultad', isEqualTo: 'Medio')
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
        _score += 200 + (_streak * 10); // Base score + streak bonus
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
      final rankingRef = FirebaseFirestore.instance.collection('rankings');
      final querySnapshot = await rankingRef
          .where('userId', isEqualTo: _currentUser!.uid)
          .where('game', isEqualTo: 'TrueFalse')
          .where('level', isEqualTo: 'Medio')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Ya existe un ranking para este usuario y nivel
        final existingRanking = querySnapshot.docs.first;
        int existingScore = existingRanking['score'];

        if (_score > existingScore) {
          // Actualizar el puntaje si es mayor
          await rankingRef.doc(existingRanking.id).update({
            'score': _score,
          });
        }
      } else {
        // Crear un nuevo documento de ranking
        final ranking = Ranking(
          id: rankingRef.doc().id,
          userId: _currentUser!.uid,
          score: _score,
          game: 'TrueFalse', // Puedes cambiarlo según el tipo de juego
          level: 'Medio', // Cambiar según el nivel de dificultad actual
        );

        await rankingRef.doc(ranking.id).set(ranking.toMap());
      }
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
        title: Text(
          '¡Fin del juego!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Has respondido todas las preguntas.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Puntuación final:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '$_score',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('OK', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Verdadero o Falso - Medio'),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    TrueFalseQuestion currentQuestion = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Verdadero o Falso - Medio'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (currentQuestion.imagenURL != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(currentQuestion.imagenURL!),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                currentQuestion.pregunta,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _isAnswered ? null : () => _checkAnswer(true),
                    child: Text(
                      'Verdadero',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswered
                          ? currentQuestion.respuestaCorrecta
                              ? Colors.green
                              : Colors.red
                          : Colors.teal,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isAnswered ? null : () => _checkAnswer(false),
                    child: Text(
                      'Falso',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswered
                          ? !currentQuestion.respuestaCorrecta
                              ? Colors.green
                              : Colors.red
                          : Colors.teal,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 46.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Tiempo restante: $_timeLeft',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Puntuación: $_score',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Racha: $_streak',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                    ],
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
