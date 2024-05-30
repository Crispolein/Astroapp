import 'package:astro_app/vistausuario2/admin/CrearYeditarD/editar_imagenes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditardQuizPage extends StatefulWidget {
  @override
  _EditardQuizPageState createState() => _EditardQuizPageState();
}

class _EditardQuizPageState extends State<EditardQuizPage> {
  List<String> _categorias = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final imagesSnapshot =
        await FirebaseFirestore.instance.collection('memoryImages').get();
    final categoriesWithImages = imagesSnapshot.docs
        .where((doc) => doc.data().containsKey('categoria'))
        .map((doc) => doc['categoria'] as String)
        .toSet()
        .toList();

    setState(() {
      _categorias = categoriesWithImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Imágenes de Memoria'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categorías con Imágenes',
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
                                  EditarImagenesPage(categoria: category),
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
                    'No hay categorías con imágenes',
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
