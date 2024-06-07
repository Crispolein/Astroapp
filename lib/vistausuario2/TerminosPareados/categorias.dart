import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'terminos_pareados_juego.dart';

class CategoriaSeleccionScreen extends StatefulWidget {
  @override
  _CategoriaSeleccionScreenState createState() =>
      _CategoriaSeleccionScreenState();
}

class _CategoriaSeleccionScreenState extends State<CategoriaSeleccionScreen> {
  List<String> _categorias = [];

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    final snapshot = await FirebaseFirestore.instance.collection('terms').get();
    final categorias = snapshot.docs
        .map((doc) => doc.data()['categoria'] as String)
        .toSet()
        .toList();
    setState(() {
      _categorias = categorias;
    });
  }

  void _seleccionarCategoria(String categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TerminosPareadosJuegoScreen(categoria: categoria),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Categoría'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: _categorias.isEmpty
            ? const CircularProgressIndicator()
            : Padding(
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
                          'Categorías Disponibles',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _categorias.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  title: Text(
                                    _categorias[index],
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () =>
                                      _seleccionarCategoria(_categorias[index]),
                                ),
                              );
                            },
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
