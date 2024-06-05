import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/admin/CrearYeditarB/editartruefalse.dart';

class ListarTrueFalsePage extends StatefulWidget {
  @override
  _ListarTrueFalsePageState createState() => _ListarTrueFalsePageState();
}

class _ListarTrueFalsePageState extends State<ListarTrueFalsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Preguntas de V/F'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('truefalse').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final questions = snapshot.data!.docs
                .map((doc) => TrueFalseQuestion.fromMap(
                    doc.data() as Map<String, dynamic>))
                .toList();

            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: question.imagenURL != null
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  content: Image.network(question.imagenURL!),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                question.imagenURL!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(
                      question.pregunta,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Respuesta Correcta: ${question.respuestaCorrecta ? 'Verdadero' : 'Falso'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.teal),
                          iconSize: 40.0, // Tamaño del icono de editar
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditarTrueFalsePage(question: question),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          iconSize: 40.0, // Tamaño del icono de eliminar
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('truefalse')
                                .doc(question.id)
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
    );
  }
}
