import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibration/vibration.dart';

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
  int _score = 0;
  int _streak = 0;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
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
      _score += 10 * (_streak + 1); // Incrementar el puntaje basado en la racha
      _streak += 1; // Incrementar la racha
    });
    _vibrateOnCorrect(); // Vibración para emparejamiento correcto

    if (_terminos.isEmpty || _definitions.isEmpty) {
      _guardarPuntaje();
      _mostrarPantallaFinal();
    }
  }

  void _descontarPuntajePorError() {
    setState(() {
      _score -= 5; // Descontar puntos por error
      _streak = 0; // Reiniciar la racha
    });
    _vibrateOnIncorrect(); // Vibración para emparejamiento incorrecto
    _mostrarAlertaError(); // Mostrar alerta de error
  }

  void _guardarPuntaje() async {
    if (_currentUser != null) {
      await FirebaseFirestore.instance.collection('rankings').add({
        'userId': _currentUser!.uid,
        'username': _currentUser!.displayName ?? 'Desconocido',
        'score': _score,
        'game': 'TerminosPareados',
        'level': widget.categoria,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void _mostrarPantallaFinal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Juego Terminado!'),
        content: Text('Tu puntaje final es $_score puntos.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Volver a la pantalla anterior
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _mostrarAlertaError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Respuesta incorrecta, se descontaron puntos.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_terminos.isEmpty || _definitions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Términos Pareados'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Términos Pareados'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Puntaje: $_score', style: TextStyle(fontSize: 24.0)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _terminos.map((termino) {
                      return Draggable<Term>(
                        data: termino,
                        child: _buildCard(termino.term),
                        feedback: Material(
                          child: _buildCard(termino.term),
                          elevation: 4.0,
                        ),
                        childWhenDragging:
                            _buildCard(termino.term, Colors.grey.shade200),
                        onDragEnd: (details) {
                          if (!details.wasAccepted) {
                            _descontarPuntajePorError(); // Descontar puntaje si no fue aceptado
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _definitions.map((definition) {
                      return DragTarget<Term>(
                        onAccept: (receivedTerm) {
                          if (receivedTerm.definition ==
                              definition.definition) {
                            _eliminarTerminosPareados(receivedTerm, definition);
                          } else {
                            _descontarPuntajePorError(); // Descontar puntaje por error
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          return _buildCard(definition.definition);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String text, [Color color = Colors.white]) {
    return Container(
      width: double.infinity,
      height: 100, // Altura fija para todas las tarjetas
      constraints:
          BoxConstraints(maxWidth: 200), // Ancho fijo para todas las tarjetas
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }
}
