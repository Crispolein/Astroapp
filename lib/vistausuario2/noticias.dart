import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/admin/ApodPage.dart';
import 'package:astro_app/vistausuario2/view_noticia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translator/translator.dart';
import 'package:astro_app/api/apod.dart';
import 'package:intl/intl.dart';

class NoticiasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(Icons.menu),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(FontAwesomeIcons.globe),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Imagen del día',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            FutureBuilder<ApodApi>(
              future: fetchApod(
                  date: DateFormat('yyyy-MM-dd').format(DateTime.now())),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final apodData = snapshot.data;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ApodPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[800],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(8)),
                            child: Image.network(
                              apodData!.url!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder<String>(
                              future: GoogleTranslator()
                                  .translate(apodData.title ?? '', to: 'es')
                                  .then((value) => value.text),
                              builder: (context, translateSnapshot) {
                                if (translateSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (translateSnapshot.hasError) {
                                  return Text(
                                    'Error: ${translateSnapshot.error}',
                                    style: TextStyle(color: Colors.white),
                                  );
                                } else if (translateSnapshot.hasData) {
                                  return Text(
                                    translateSnapshot.data ??
                                        'Título no disponible',
                                    style: TextStyle(color: Colors.white),
                                  );
                                } else {
                                  return Text(
                                    'No translation available',
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
            SizedBox(height: 16),
            Text(
              'Noticias',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('noticia')
                  .orderBy('timestamp', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No hay noticias disponibles'));
                }

                final noticiaDoc = snapshot.data!.docs.first;
                final noticiaData = noticiaDoc.data() as Map<String, dynamic>;
                final noticia = Noticia(
                  id: noticiaDoc.id,
                  categoria: noticiaData['categoria'] ?? '',
                  titulo: noticiaData['titulo'] ?? '',
                  descripcion: noticiaData['descripcion'] ?? '',
                  imagenURL: noticiaData['imagenURL'] ?? '',
                  timestamp: noticiaData['timestamp'] ?? Timestamp.now(),
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListarNoticiaLectura()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[800],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: noticia.imagenURL.isNotEmpty
                                ? Image.network(
                                    noticia.imagenURL,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.image,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              noticia.titulo,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
