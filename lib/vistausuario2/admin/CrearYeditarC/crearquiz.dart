import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:astro_app/vistausuario2/categoria/listarcategoria.dart';
import 'package:astro_app/models/proyecto_model.dart';

class CrearcQuizPage extends StatefulWidget {
  @override
  _CrearcQuizPageState createState() => _CrearcQuizPageState();
}

class _CrearcQuizPageState extends State<CrearcQuizPage> {
  final List<TextEditingController> _termControllers = [];
  final List<TextEditingController> _definitionControllers = [];
  String _categoriaSeleccionada = '';
  List<String> _categorias = [];

  @override
  void initState() {
    super.initState();
    _addTermDefinitionPair();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categoria').get();
    setState(() {
      _categorias =
          snapshot.docs.map((doc) => doc['categoria'] as String).toList();
    });
  }

  void _addTermDefinitionPair() {
    setState(() {
      _termControllers.add(TextEditingController());
      _definitionControllers.add(TextEditingController());
    });
  }

  void _removeTermDefinitionPair(int index) {
    if (_termControllers.length > 1 && _definitionControllers.length > 1) {
      setState(() {
        _termControllers[index].dispose();
        _definitionControllers[index].dispose();
        _termControllers.removeAt(index);
        _definitionControllers.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Debe haber al menos un término y una definición')));
    }
  }

  void _saveTerms() async {
    if (_termControllers.isEmpty || _definitionControllers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, añade al menos un término y definición')));
      return;
    }

    if (!_categorias.contains(_categoriaSeleccionada)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, selecciona una categoría válida')));
      return;
    }

    List<Term> terms = [];
    for (int i = 0; i < _termControllers.length; i++) {
      String termText = _termControllers[i].text.trim();
      String definitionText = _definitionControllers[i].text.trim();

      // Verifica si los campos no están vacíos
      if (termText.isEmpty || definitionText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Por favor, llena todos los términos y definiciones antes de guardar')));
        return;
      }

      terms.add(Term(
        id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
        term: termText,
        definition: definitionText,
        categoria: _categoriaSeleccionada,
      ));
    }

    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var term in terms) {
        final docRef =
            FirebaseFirestore.instance.collection('terms').doc(term.id);
        batch.set(docRef, term.toMap());
      }
      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Términos guardados con éxito')));
      Navigator.pop(context); // Redirige a la página anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los términos: $e')));
    }
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
              Text(
                'Categoría',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return _categorias.where((String option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        _categoriaSeleccionada = selection;
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Categoría',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (_categorias.contains(value)) {
                              setState(() {
                                _categoriaSeleccionada = value;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaCategorias(),
                        ),
                      ).then((value) {
                        _cargarCategorias();
                      });
                    },
                  ),
                ],
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
                    onPressed: _saveTerms,
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
