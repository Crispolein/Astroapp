import 'package:astro_app/vistausuario2/admin/CrearYeditarD/editar_imagenes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditardQuizPage extends StatefulWidget {
  @override
  _EditardQuizPageState createState() => _EditardQuizPageState();
}

class _EditardQuizPageState extends State<EditardQuizPage> {
  List<String> _categorias = [];
  String _searchText = '';

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
    final filteredCategories = _categorias
        .where((category) =>
            category.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Imágenes de Memoria'),
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
                    'Categorías con Imágenes',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Buscar categoría',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  if (filteredCategories.isNotEmpty)
                    Column(
                      children: filteredCategories.map((category) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              category,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
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
                    const Center(
                      child: Text(
                        'No hay categorías con imágenes',
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
