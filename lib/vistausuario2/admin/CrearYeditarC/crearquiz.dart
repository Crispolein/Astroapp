import 'package:flutter/material.dart';

class CrearcQuizPage extends StatefulWidget {
  @override
  _CrearcQuizPageState createState() => _CrearcQuizPageState();
}

class _CrearcQuizPageState extends State<CrearcQuizPage> {
  final List<TextEditingController> _termControllers = [];
  final List<TextEditingController> _definitionControllers = [];

  @override
  void initState() {
    super.initState();
    _addTermDefinitionPair();
  }

  void _addTermDefinitionPair() {
    setState(() {
      _termControllers.add(TextEditingController());
      _definitionControllers.add(TextEditingController());
    });
  }

  void _removeTermDefinitionPair(int index) {
    setState(() {
      _termControllers.removeAt(index);
      _definitionControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in _termControllers) {
      controller.dispose();
    }
    for (var controller in _definitionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Quiz de Pareados'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Términos y Definiciones',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Column(
                children: List.generate(_termControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _termControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Introduce el término...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            controller: _definitionControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Introduce la definición...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.red,
                          onPressed: () {
                            _removeTermDefinitionPair(index);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 10.0),
              Center(
                child: ElevatedButton(
                  onPressed: _addTermDefinitionPair,
                  child: Text('Agregar Término y Definición'),
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
                      // Aquí iría la lógica para guardar los términos y definiciones
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
