import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarTerminosPage extends StatefulWidget {
  final String categoria;

  const EditarTerminosPage({required this.categoria})
      : super(key: const Key(''));

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
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Términos y Definiciones',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  if (_terms.isNotEmpty)
                    Column(
                      children: _terms.map((term) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Término: ${term['term']}',
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        'Definición: ${term['definition']}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue, size: 35.0),
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
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 35.0),
                                  onPressed: () {
                                    _deleteTerm(term['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    const Center(
                      child: Text(
                        'No hay términos para esta categoría',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                ],
              ),
            ),
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
          title: const Text('Editar Término y Definición'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: termController,
                decoration: InputDecoration(
                  labelText: 'Término',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: definitionController,
                decoration: InputDecoration(
                  labelText: 'Definición',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
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
