import 'dart:async';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración

class VerdaderoFalsoDificilScreen extends StatefulWidget {
  @override
  _VerdaderoFalsoDificilScreenState createState() =>
      _VerdaderoFalsoDificilScreenState();
}

class _VerdaderoFalsoDificilScreenState
    extends State<VerdaderoFalsoDificilScreen> {
  List<TrueFalseQuestion> _questions = [];
  int _currentIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    FirebaseFirestore.instance
        .collection('truefalse')
        .where('dificultad', isEqualTo: 'Dificil')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _questions = querySnapshot.docs
            .map((doc) =>
                TrueFalseQuestion.fromMap(doc.data() as Map<String, dynamic>))
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

  void _checkAnswer(bool selectedAnswer) {
    setState(() {
      _isAnswered = true;
      _isCorrect =
          selectedAnswer == _questions[_currentIndex].respuestaCorrecta;
    });

    if (_isCorrect) {
      _vibrateOnCorrect(); // Vibración para respuesta correcta
    } else {
      _vibrateOnIncorrect(); // Vibración para respuesta incorrecta
    }

    Timer(Duration(seconds: 2), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _questions.length;
        _isAnswered = false;
      });
    });
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
        title: Text('Verdadero o Falso - Dificil'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (currentQuestion.imagenURL != null)
              Expanded(
                flex: 1,
                child: Image.network(currentQuestion.imagenURL!),
              ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentQuestion.pregunta,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _isAnswered ? null : () => _checkAnswer(true),
                        child: Text(
                          'Verdadero',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: _isAnswered
                              ? currentQuestion.respuestaCorrecta
                                  ? Colors.green
                                  : Colors.red
                              : Colors.teal,
                          minimumSize: Size(140, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            _isAnswered ? null : () => _checkAnswer(false),
                        child: Text(
                          'Falso',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: _isAnswered
                              ? !currentQuestion.respuestaCorrecta
                                  ? Colors.green
                                  : Colors.red
                              : Colors.teal,
                          minimumSize: Size(140, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isAnswered)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
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
          ],
        ),
      ),
    );
  }
}
