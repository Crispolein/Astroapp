import 'package:flutter/material.dart';

class PersonalizarcQuizPage extends StatefulWidget {
  @override
  _PersonalizarcQuizPageState createState() => _PersonalizarcQuizPageState();
}

class _PersonalizarcQuizPageState extends State<PersonalizarcQuizPage> {
  String _selectedCategory = 'Categoría 1';
  int _selectedDifficulty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personalizar Quiz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seleccione una Categoría',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Categoría 1', 'Categoría 2', 'Categoría 3']
                    .map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Categoría',
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Seleccione la Dificultad',
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
                  children: [
                    RadioListTile<int>(
                      title: Text('Fácil'),
                      value: 1,
                      groupValue: _selectedDifficulty,
                      onChanged: (value) {
                        setState(() {
                          _selectedDifficulty = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('Medio'),
                      value: 2,
                      groupValue: _selectedDifficulty,
                      onChanged: (value) {
                        setState(() {
                          _selectedDifficulty = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text('Difícil'),
                      value: 3,
                      groupValue: _selectedDifficulty,
                      onChanged: (value) {
                        setState(() {
                          _selectedDifficulty = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para aplicar la personalización al quiz
                    },
                    child: Text(
                      'Aplicar',
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
