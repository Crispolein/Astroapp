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

  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(
          duration: 50); // Duración de la vibración en milisegundos
    }
  }

  void _eliminarTerminosPareados(Term termino, Term definicion) {
    setState(() {
      _terminos.remove(termino);
      _definitions.remove(definicion);
    });
    _vibrate(); // Activar vibración al emparejar correctamente
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
        child: Row(
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
                      if (receivedTerm.definition == definition.definition) {
                        _eliminarTerminosPareados(receivedTerm, definition);
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
      ),
    );
  }

  Widget _buildCard(String text, [Color color = Colors.white]) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
