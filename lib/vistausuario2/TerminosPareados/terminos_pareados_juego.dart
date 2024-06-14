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

  Future<void> _guardarPuntaje() async {
    if (_currentUser != null) {
      final rankingRef = FirebaseFirestore.instance.collection('rankings');
      final querySnapshot = await rankingRef
          .where('userId', isEqualTo: _currentUser!.uid)
          .where('game', isEqualTo: 'Terms')
          .where('level', isEqualTo: widget.categoria)
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
        final newRanking = Ranking(
          id: rankingRef.doc().id,
          userId: _currentUser!.uid,
          score: _score,
          game: 'Terms',
          level: widget.categoria,
        );

        await rankingRef.doc(newRanking.id).set(newRanking.toMap());
      }
    }
  }

  void _mostrarPantallaFinal() {
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
              'Tu puntaje final es $_score puntos.',
              style: TextStyle(fontSize: 18),
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

  void _mostrarAlertaError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
                child: Text('Respuesta incorrecta, se descontaron puntos.')),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
      ),
    );
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
        child: Column(
          children: [
            Text('Puntaje: $_score', style: TextStyle(fontSize: 24.0)),
            SizedBox(height: 20.0),
            Expanded(
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
                              childWhenDragging: _buildLeftCard(
                                  termino.term, Colors.grey.shade200),
                              onDragEnd: (details) {
                                if (!details.wasAccepted) {
                                  _descontarPuntajePorError(); // Descontar puntaje si no fue aceptado
                                }
                              },
                            ),
                            const SizedBox(
                                height: 16.0), // Espacio entre botones
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
                                  _eliminarTerminosPareados(
                                      receivedTerm, definition);
                                } else {
                                  _descontarPuntajePorError(); // Descontar puntaje por error
                                }
                              },
                              builder: (context, candidateData, rejectedData) {
                                return _buildRightCard(
                                    definition.definition, Colors.teal.shade50);
                              },
                            ),
                            const SizedBox(
                                height: 16.0), // Espacio entre botones
                          ],
                        );
                      }).toList(),
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
