import 'package:astro_app/vistausuario2/TerminosPareados/ranking_pareado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoriasJugadasScreen extends StatefulWidget {
  @override
  _CategoriasJugadasScreenState createState() =>
      _CategoriasJugadasScreenState();
}

class _CategoriasJugadasScreenState extends State<CategoriasJugadasScreen> {
  List<String> _categoriasJugadas = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCategoriasJugadas();
  }

  Future<void> _fetchCategoriasJugadas() async {
    try {
      // Obtener todas las categorías (niveles) que tienen ranking para el juego 'Terms'
      final snapshot = await FirebaseFirestore.instance
          .collection('rankings')
          .where('game', isEqualTo: 'Terms')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _categoriasJugadas = snapshot.docs
              .where((doc) => doc.data().containsKey('level'))
              .map((doc) => doc['level'] as String)
              .toSet()
              .toList();
        });
      } else {
        print('No se encontraron categorías jugadas');
      }
    } catch (e) {
      print('Error al obtener las categorías jugadas: $e');
      setState(() {
        _errorMessage = 'Error al obtener las categorías jugadas: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _verRanking(String categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RankingCategoriaScreen(categoria: categoria),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías Jugadas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _categoriasJugadas.isEmpty
                  ? Center(child: Text('No se encontraron categorías jugadas'))
                  : ListView.builder(
                      itemCount: _categoriasJugadas.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_categoriasJugadas[index]),
                          onTap: () => _verRanking(_categoriasJugadas[index]),
                        );
                      },
                    ),
    );
  }
}
