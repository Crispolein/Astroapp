import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración
import 'package:astro_app/vistausuario2/view_noticia_completa.dart';

class ListarNoticiaLectura extends StatefulWidget {
  const ListarNoticiaLectura({Key? key}) : super(key: key);

  @override
  _ListarNoticiaLecturaState createState() => _ListarNoticiaLecturaState();
}

class _ListarNoticiaLecturaState extends State<ListarNoticiaLectura> {
  final CollectionReference noticiaCollection =
      FirebaseFirestore.instance.collection('noticia');
  String _filtroTexto = '';

  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(duration: 50); // Duración de la vibración en milisegundos
    }
  }

  void _mostrarImagenAgrandada(String imagenURL) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Image.network(imagenURL, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filtrar por título o categoría',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                setState(() {
                  _filtroTexto = value;
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: noticiaCollection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final noticiaDocs = snapshot.data!.docs.where((doc) {
              final noticiaData = doc.data() as Map<String, dynamic>;
              final titulo = noticiaData['titulo'] ?? '';
              final categoria = noticiaData['categoria'] ?? '';
              return titulo
                      .toLowerCase()
                      .contains(_filtroTexto.toLowerCase()) ||
                  categoria.toLowerCase().contains(_filtroTexto.toLowerCase());
            }).toList();

            return ListView.builder(
                itemCount: noticiaDocs.length,
                itemBuilder: (context, index) {
                  final noticiaDoc = noticiaDocs[index];
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
                            builder: (context) =>
                                NoticiaCompletaPage(noticia: noticia)),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _vibrate(); // Activar vibración al tocar la imagen
                                if (noticia.imagenURL.isNotEmpty) {
                                  _mostrarImagenAgrandada(noticia.imagenURL);
                                }
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: noticia.imagenURL.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(noticia.imagenURL),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: noticia.imagenURL.isEmpty
                                    ? Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    noticia.titulo,
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Categoría: ${noticia.categoria}',
                                    style: const TextStyle(fontSize: 16, color: Colors.teal),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    noticia.descripcion,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
