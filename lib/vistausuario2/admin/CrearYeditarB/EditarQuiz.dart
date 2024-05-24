import 'package:flutter/material.dart';

class EditarbQuizPage extends StatefulWidget {
  @override
  _EditarbQuizPageState createState() => _EditarbQuizPageState();
}

class _EditarbQuizPageState extends State<EditarbQuizPage> {
  int _selectedQuestionIndex = 0;
  final List<String> _questions = [
    '¿La capital de Francia es París?',
    '¿La capital de España es Madrid?',
    '¿La capital de Italia es Roma?',
    '¿La capital de Alemania es Berlín?',
  ];
  final Map<int, bool> _correctAnswers = {
    0: true,
    1: true,
    2: true,
    3: true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Quiz de V/F'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecciona Pregunta',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              DropdownButton<int>(
                value: _selectedQuestionIndex,
                items: List.generate(
                  _questions.length,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text(_questions[index]),
                  ),
                ),
                onChanged: (int? value) {
                  setState(() {
                    _selectedQuestionIndex = value!;
                  });
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Editar Pregunta',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: _questions[_selectedQuestionIndex],
                onChanged: (newValue) {
                  setState(() {
                    _questions[_selectedQuestionIndex] = newValue;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Introduce la pregunta...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              SizedBox(height: 20.0),
              Text(
                'Respuesta Correcta',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              SwitchListTile(
                title: Text('¿Es verdadero?'),
                value: _correctAnswers[_selectedQuestionIndex]!,
                onChanged: (bool value) {
                  setState(() {
                    _correctAnswers[_selectedQuestionIndex] = value;
                  });
                },
              ),
              SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí iría la lógica para guardar los cambios realizados en el quiz
                    },
                    child: Text(
                      'Guardar Cambios',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
