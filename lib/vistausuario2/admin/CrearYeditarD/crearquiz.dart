import 'package:flutter/material.dart';

class CreardQuizPage extends StatefulWidget {
  @override
  _CreardQuizPageState createState() => _CreardQuizPageState();
}

class _CreardQuizPageState extends State<CreardQuizPage> {
  final List<TextEditingController> _questionControllers = [];
  final List<TextEditingController> _answerControllers = [];

  @override
  void initState() {
    super.initState();
    _addQuestionAnswerPair();
  }

  void _addQuestionAnswerPair() {
    setState(() {
      _questionControllers.add(TextEditingController());
      _answerControllers.add(TextEditingController());
    });
  }

  void _removeQuestionAnswerPair(int index) {
    setState(() {
      _questionControllers.removeAt(index);
      _answerControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in _questionControllers) {
      controller.dispose();
    }
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Quiz de Preguntas Abiertas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preguntas Abiertas',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Column(
                children: List.generate(_questionControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _questionControllers[index],
                                decoration: InputDecoration(
                                  hintText: 'Introduce la pregunta...',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: null,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_circle),
                              color: Colors.red,
                              onPressed: () {
                                _removeQuestionAnswerPair(index);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _answerControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Introduce la respuesta...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: null,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 10.0),
              Center(
                child: ElevatedButton(
                  onPressed: _addQuestionAnswerPair,
                  child: Text('Agregar Pregunta y Respuesta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí iría la lógica para guardar las preguntas y respuestas
                    },
                    child: Text(
                      'Guardar Quiz',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
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
