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
    if (_categorias.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Seleccionar Categoría'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Categoría'),
      ),
      body: ListView.builder(
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_categorias[index]),
            onTap: () => _seleccionarCategoria(_categorias[index]),
          );
        },
      ),
    );
  }
}
