import 'package:flutter/material.dart';

class EditardQuizPage extends StatefulWidget {
  @override
  _EditardQuizPageState createState() => _EditardQuizPageState();
}

class _EditardQuizPageState extends State<EditardQuizPage> {
  int _selectedQuestionIndex = 0;
  final List<List<String>> _questionsAndAnswers = [
    ['¿Cuál es la capital de Francia?', 'París'],
    ['¿Cuál es la capital de España?', 'Madrid'],
    ['¿Cuál es la capital de Italia?', 'Roma'],
    ['¿Cuál es la capital de Alemania?', 'Berlín'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Quiz de Preguntas Abiertas'),
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
                  _questionsAndAnswers.length,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text('Pregunta ${index + 1}'),
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
                'Editar Pregunta y Respuesta',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Column(
                children: [
                  _buildQuestionAnswerField('Pregunta',
                      _questionsAndAnswers[_selectedQuestionIndex][0],
                      (newValue) {
                    setState(() {
                      _questionsAndAnswers[_selectedQuestionIndex][0] =
                          newValue;
                    });
                  }),
                  SizedBox(height: 10.0),
                  _buildQuestionAnswerField('Respuesta',
                      _questionsAndAnswers[_selectedQuestionIndex][1],
                      (newValue) {
                    setState(() {
                      _questionsAndAnswers[_selectedQuestionIndex][1] =
                          newValue;
                    });
                  }),
                ],
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

  Widget _buildQuestionAnswerField(
      String label, String initialValue, ValueChanged<String> onChanged) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
