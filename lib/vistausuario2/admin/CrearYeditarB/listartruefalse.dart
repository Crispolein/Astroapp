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
        title: Text('Listar Preguntas de V/F'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('truefalse').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final questions = snapshot.data!.docs
              .map((doc) =>
                  TrueFalseQuestion.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return Card(
                margin: EdgeInsets.all(10.0),
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
                          child: Image.network(question.imagenURL!,
                              width: 50, height: 50, fit: BoxFit.cover),
                        )
                      : Icon(Icons.image_not_supported),
                  title: Text(question.pregunta),
                  subtitle: Text(
                      'Respuesta Correcta: ${question.respuestaCorrecta ? 'Verdadero' : 'Falso'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
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
                        icon: Icon(Icons.delete),
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
    );
  }
}
