import 'package:flutter/material.dart';

class EditarcQuizPage extends StatefulWidget {
  @override
  _EditarcQuizPageState createState() => _EditarcQuizPageState();
}

class _EditarcQuizPageState extends State<EditarcQuizPage> {
  int _selectedQuestionIndex = 0;
  final List<List<String>> _pairs = [
    ['París', 'Capital de Francia'],
    ['Madrid', 'Capital de España'],
    ['Roma', 'Capital de Italia'],
    ['Berlín', 'Capital de Alemania'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Quiz de Pareados'),
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
                  _pairs.length,
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
                'Editar Términos y Definiciones',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Column(
                children: [
                  _buildPairField('Término', _pairs[_selectedQuestionIndex][0],
                      (newValue) {
                    setState(() {
                      _pairs[_selectedQuestionIndex][0] = newValue;
                    });
                  }),
                  SizedBox(height: 10.0),
                  _buildPairField(
                      'Definición', _pairs[_selectedQuestionIndex][1],
                      (newValue) {
                    setState(() {
                      _pairs[_selectedQuestionIndex][1] = newValue;
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

  Widget _buildPairField(
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
