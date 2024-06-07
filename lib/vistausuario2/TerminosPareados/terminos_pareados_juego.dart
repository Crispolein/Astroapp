import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración
import 'dart:math';

class TerminosPareadosJuegoScreen extends StatefulWidget {
  final String categoria;

  TerminosPareadosJuegoScreen({required this.categoria});

  @override
  _TerminosPareadosJuegoScreenState createState() =>
      _TerminosPareadosJuegoScreenState();
}

class _TerminosPareadosJuegoScreenState
    extends State<TerminosPareadosJuegoScreen> {
  List<Term> _terminos = [];
  List<Term> _definitions = [];

  @override
  void initState() {
    super.initState();
    _cargarTerminos();
  }

  Future<void> _cargarTerminos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('terms')
        .where('categoria', isEqualTo: widget.categoria)
        .get();
    setState(() {
      List<Term> allTerms = snapshot.docs
          .map((doc) => Term.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      allTerms.shuffle(); // Mezclar todos los términos
      _terminos = allTerms.take(8).toList(); // Tomar los primeros 8 términos
      _definitions = List.from(_terminos);
      _definitions.shuffle(); // Mezclar definiciones para desordenarlas
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

  void _eliminarTerminosPareados(Term termino, Term definicion) {
    setState(() {
      _terminos.remove(termino);
      _definitions.remove(definicion);
    });
    _vibrateOnCorrect(); // Vibración para emparejamiento correcto
  }

  @override
  Widget build(BuildContext context) {
    if (_terminos.isEmpty || _definitions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Términos Pareados'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos Pareados'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _terminos.map((termino) {
                  return Column(
                    children: [
                      Draggable<Term>(
                        data: termino,
                        child: _buildLeftCard(termino.term),
                        feedback: Material(
                          child: _buildLeftCard(
                              termino.term, Colors.teal.shade100),
                          elevation: 4.0,
                        ),
                        childWhenDragging:
                            _buildLeftCard(termino.term, Colors.grey.shade200),
                        onDragEnd: (details) {
                          if (!details.wasAccepted) {
                            _vibrateOnIncorrect(); // Vibración para emparejamiento incorrecto
                          }
                        },
                      ),
                      const SizedBox(height: 16.0), // Espacio entre botones
                    ],
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _definitions.map((definition) {
                  return Column(
                    children: [
                      DragTarget<Term>(
                        onAccept: (receivedTerm) {
                          if (receivedTerm.definition ==
                              definition.definition) {
                            _eliminarTerminosPareados(receivedTerm, definition);
                          } else {
                            _vibrateOnIncorrect(); // Vibración para emparejamiento incorrecto
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          return _buildRightCard(
                              definition.definition, Colors.teal.shade50);
                        },
                      ),
                      const SizedBox(height: 16.0), // Espacio entre botones
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftCard(String text, [Color color = Colors.teal]) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 135, // Ajusta el ancho
        height: 120, // Ajusta el alto
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildRightCard(String text, [Color color = Colors.white]) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 135, // Ajusta el ancho
        height: 120, // Ajusta el alto
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18.0, color: Colors.teal),
          ),
        ),
      ),
    );
  }
}
