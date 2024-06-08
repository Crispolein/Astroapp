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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Seleccionar Categoría',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Icon(Icons.category, size: 28),
          ],
        ),
        backgroundColor: Colors.teal,
      ),
      body: _categorias.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // Añadir espacio debajo del AppBar
              child: ListView.builder(
                itemCount: _categorias.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    elevation: 3,
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      title: Text(
                        _categorias[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward_ios, color: Colors.teal),
                      onTap: () => _seleccionarCategoria(_categorias[index]),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
