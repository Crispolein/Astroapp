import 'package:astro_app/vistausuario2/admin/CrearYeditarC/editar_terminos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarcQuizPage extends StatefulWidget {
  @override
  _EditarcQuizPageState createState() => _EditarcQuizPageState();
}

class _EditarcQuizPageState extends State<EditarcQuizPage> {
  List<String> _categorias = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final termsSnapshot =
        await FirebaseFirestore.instance.collection('terms').get();
    final categoriesWithTerms = termsSnapshot.docs
        .where((doc) => doc.data().containsKey('categoria'))
        .map((doc) => doc['categoria'] as String)
        .toSet()
        .toList();

    setState(() {
      _categorias = categoriesWithTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Quiz de Pareados'),
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
                    'Categorías con Términos',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  if (_categorias.isNotEmpty)
                    Column(
                      children: _categorias.map((category) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward,
                                color: Colors.teal),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditarTerminosPage(categoria: category),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    )
                  else
                    const Center(
                      child: Text(
                        'No hay categorías con términos',
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
}
