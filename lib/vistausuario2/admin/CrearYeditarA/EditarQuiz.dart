import 'package:flutter/material.dart';

class EditarQuizPage extends StatefulWidget {
  @override
  _EditarQuizPageState createState() => _EditarQuizPageState();
}

class _EditarQuizPageState extends State<EditarQuizPage> {
  int _selectedQuestionIndex = 0;
  final List<String> _questions = [
    '¿Cuál es la capital de Francia?',
    '¿Cuál es la capital de España?',
    '¿Cuál es la capital de Italia?',
    '¿Cuál es la capital de Alemania?',
  ];
  final Map<int, List<String>> _options = {
    0: ['París', 'Madrid', 'Roma', 'Berlín'],
    1: ['Barcelona', 'Madrid', 'Sevilla', 'Valencia'],
    2: ['Milán', 'Roma', 'Nápoles', 'Florencia'],
    3: ['Múnich', 'Berlín', 'Hamburgo', 'Frankfurt'],
  };
  final Map<int, String> _correctAnswers = {
    0: 'París',
    1: 'Madrid',
    2: 'Roma',
    3: 'Berlín',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Quiz De Alternarivas'),
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
                'Editar Opciones',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TextFormField(
                        initialValue: _options[_selectedQuestionIndex]![index],
                        onChanged: (newValue) {
                          setState(() {
                            _options[_selectedQuestionIndex]![index] = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Introduce la opción ${index + 1}...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                      ),
                    );
                  }),
                ),
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
              TextFormField(
                initialValue: _correctAnswers[_selectedQuestionIndex],
                onChanged: (newValue) {
                  setState(() {
                    _correctAnswers[_selectedQuestionIndex] = newValue;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Introduce la respuesta correcta...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
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
                        color: Colors.purple,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
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
