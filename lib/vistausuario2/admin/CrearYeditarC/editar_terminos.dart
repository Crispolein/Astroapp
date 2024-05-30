import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarTerminosPage extends StatefulWidget {
  final String categoria;

  EditarTerminosPage({required this.categoria});

  @override
  _EditarTerminosPageState createState() => _EditarTerminosPageState();
}

class _EditarTerminosPageState extends State<EditarTerminosPage> {
  List<Map<String, dynamic>> _terms = [];

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('terms')
        .where('categoria', isEqualTo: widget.categoria)
        .get();
    setState(() {
      _terms = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'term': doc['term'],
                'definition': doc['definition'],
              })
          .toList();
    });
  }

  void _editTerm(String id, String newTerm, String newDefinition) async {
    await FirebaseFirestore.instance.collection('terms').doc(id).update({
      'term': newTerm,
      'definition': newDefinition,
    });
    _loadTerms();
  }

  void _deleteTerm(String id) async {
    await FirebaseFirestore.instance.collection('terms').doc(id).delete();
    _loadTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoría: ${widget.categoria}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_terms.isNotEmpty)
                Column(
                  children: _terms.map((term) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Término: ${term['term']}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  'Definición: ${term['definition']}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () async {
                              final editedValues = await _showEditDialog(
                                context,
                                term['term'],
                                term['definition'],
                              );
                              if (editedValues != null &&
                                  editedValues['term'] != null &&
                                  editedValues['definition'] != null) {
                                _editTerm(
                                  term['id'],
                                  editedValues['term']!,
                                  editedValues['definition']!,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _deleteTerm(term['id']);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              else
                Center(
                  child: Text(
                    'No hay términos para esta categoría',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, String>?> _showEditDialog(
      BuildContext context, String currentTerm, String currentDefinition) {
    final termController = TextEditingController(text: currentTerm);
    final definitionController = TextEditingController(text: currentDefinition);
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Término y Definición'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: termController,
                decoration: InputDecoration(
                  labelText: 'Término',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: definitionController,
                decoration: InputDecoration(
                  labelText: 'Definición',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                Navigator.of(context).pop({
                  'term': termController.text,
                  'definition': definitionController.text,
                });
              },
            ),
          ],
        );
      },
    );
  }
}
