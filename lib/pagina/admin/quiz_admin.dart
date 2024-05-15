import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({Key? key}) : super(key: key);

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _preguntaController = TextEditingController();
  final _respuestaController = TextEditingController();
  final _respuesta2Controller = TextEditingController();
  final _respuesta3Controller = TextEditingController();
  final _respuesta4Controller = TextEditingController();
  final _respuestaCorrectaController = TextEditingController();
  String _error = '';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _quizCollection =
      FirebaseFirestore.instance.collection('quiz');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Pregunta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _preguntaController,
                decoration: const InputDecoration(labelText: 'Pregunta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la pregunta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _respuestaController,
                decoration: const InputDecoration(labelText: 'Respuesta 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la respuesta 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _respuesta2Controller,
                decoration: const InputDecoration(labelText: 'Respuesta 2'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la respuesta 2';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _respuesta3Controller,
                decoration: const InputDecoration(labelText: 'Respuesta 3'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la respuesta 3';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _respuesta4Controller,
                decoration: const InputDecoration(labelText: 'Respuesta 4'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la respuesta 4';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _respuestaCorrectaController,
                decoration:
                    const InputDecoration(labelText: 'Respuesta Correcta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la respuesta correcta';
                  }
                  return null;
                },
              ),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final nuevoQuiz = Quiz(
                      id: '',
                      pregunta: _preguntaController.text,
                      respuesta: _respuestaController.text,
                      respuesta2: _respuesta2Controller.text,
                      respuesta3: _respuesta3Controller.text,
                      respuesta4: _respuesta4Controller.text,
                      respuestaCorrecta: _respuestaCorrectaController.text,
                    );

                    final snapshot = await _quizCollection
                        .where('pregunta', isEqualTo: nuevoQuiz.pregunta)
                        .where('respuesta', isEqualTo: nuevoQuiz.respuesta)
                        .where('respuesta2', isEqualTo: nuevoQuiz.respuesta2)
                        .where('respuesta3', isEqualTo: nuevoQuiz.respuesta3)
                        .where('respuesta4', isEqualTo: nuevoQuiz.respuesta4)
                        .where('respuestaCorrecta',
                            isEqualTo: nuevoQuiz.respuestaCorrecta)
                        .get();
                    if (snapshot.docs.isEmpty) {
                      final DocumentReference document = _quizCollection.doc();
                      final nuevoQuizConID = Quiz(
                          id: document.id,
                          pregunta: nuevoQuiz.pregunta,
                          respuesta: nuevoQuiz.respuesta,
                          respuesta2: nuevoQuiz.respuesta2,
                          respuesta3: nuevoQuiz.respuesta3,
                          respuesta4: nuevoQuiz.respuesta4,
                          respuestaCorrecta: nuevoQuiz.respuestaCorrecta);
                      await document.set({
                        'id': nuevoQuizConID.id,
                        'pregunta': nuevoQuizConID.pregunta,
                        'respuesta': nuevoQuizConID.respuesta,
                        'respuesta2': nuevoQuizConID.respuesta2,
                        'respuesta3': nuevoQuizConID.respuesta3,
                        'respuesta4': nuevoQuizConID.respuesta4,
                        'respuestaCorrecta': nuevoQuizConID.respuestaCorrecta,
                      });
                      Navigator.pop(context, nuevoQuizConID);
                    } else {
                      print("Ya existe la pregunta");
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
