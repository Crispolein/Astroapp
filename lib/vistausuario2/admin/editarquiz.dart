import 'package:flutter/material.dart';

class QuizFormPage extends StatelessWidget {
  final String mode; // Puede ser 'Crear' o 'Editar'

  const QuizFormPage({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$mode Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$mode Quiz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            mode == 'Editar'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar Dificultad:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        items: [
                          DropdownMenuItem(
                            value: 'Fácil',
                            child: Text('Fácil'),
                          ),
                          DropdownMenuItem(
                            value: 'Medio',
                            child: Text('Medio'),
                          ),
                          DropdownMenuItem(
                            value: 'Difícil',
                            child: Text('Difícil'),
                          ),
                        ],
                        onChanged: (value) {},
                        hint: Text('Selecciona la dificultad'),
                      ),
                    ],
                  )
                : Container(),
            // Añadir aquí los campos para crear/editar el quiz
            TextField(
              decoration: InputDecoration(labelText: 'Nombre del Quiz'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            // Otros campos necesarios para el quiz
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para crear o editar el quiz
              },
              child: Text('$mode Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}