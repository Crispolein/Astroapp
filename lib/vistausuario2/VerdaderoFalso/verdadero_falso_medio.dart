import 'dart:async';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    FirebaseFirestore.instance
        .collection('truefalse')
        .where('dificultad', isEqualTo: 'Medio')
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

  void _checkAnswer(bool selectedAnswer) {
    setState(() {
      _isAnswered = true;
      _isCorrect =
          selectedAnswer == _questions[_currentIndex].respuestaCorrecta;
    });

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
        title: Text('Verdadero o Falso - Medio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                children: [
                  Text(
                    currentQuestion.pregunta,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _isAnswered ? null : () => _checkAnswer(true),
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
                        onPressed:
                            _isAnswered ? null : () => _checkAnswer(false),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
