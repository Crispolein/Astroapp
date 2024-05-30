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
        title: Text('Editar Quiz de Pareados'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categorías con Términos',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              if (_categorias.isNotEmpty)
                Column(
                  children: _categorias.map((category) {
                    return Card(
                      child: ListTile(
                        title: Text(category),
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
                Center(
                  child: Text(
                    'No hay categorías con términos',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
