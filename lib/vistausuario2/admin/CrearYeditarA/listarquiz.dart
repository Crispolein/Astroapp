import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarA/EditarQuiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListarQuizPage extends StatefulWidget {
  @override
  _ListarQuizPageState createState() => _ListarQuizPageState();
}

class _ListarQuizPageState extends State<ListarQuizPage> {
  String _searchText = '';
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categoria').get();
    setState(() {
      _categories =
          snapshot.docs.map((doc) => doc['categoria'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Quizzes'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText:
                    'Buscar por categoría, pregunta o respuesta correcta',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('quizzes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final quizzes = snapshot.data!.docs
                      .map((doc) =>
                          Quiz.fromMap(doc.data() as Map<String, dynamic>))
                      .where((quiz) {
                    final searchLower = _searchText.toLowerCase();
                    final matchesCategory =
                        quiz.categoria?.toLowerCase().contains(searchLower) ??
                            false;
                    final matchesQuestion =
                        quiz.pregunta.toLowerCase().contains(searchLower);
                    final matchesCorrectAnswer = quiz.respuestaCorrecta
                        .toLowerCase()
                        .contains(searchLower);
                    return matchesCategory ||
                        matchesQuestion ||
                        matchesCorrectAnswer;
                  }).toList();

                  return ListView.builder(
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = quizzes[index];
                      return Card(
                        margin: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: quiz.imagenURL != null
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        content: Image.network(quiz.imagenURL!),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      quiz.imagenURL!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(
                            quiz.pregunta,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Respuesta Correcta: ${quiz.respuestaCorrecta}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.teal),
                                iconSize: 30.0, // Tamaño del icono de editar
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditarQuizPage(quiz: quiz)),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                iconSize: 30.0, // Tamaño del icono de eliminar
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('quizzes')
                                      .doc(quiz.id)
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
