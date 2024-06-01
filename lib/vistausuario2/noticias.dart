import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/admin/ApodPage.dart';
import 'package:astro_app/vistausuario2/view_noticia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:astro_app/api/apod.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración

class NoticiasPage extends StatelessWidget {
  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(
          duration: 50); // Duración de la vibración en milisegundos
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding:
              const EdgeInsets.only(top: 16.0), // Aquí agregamos el espacio
          child: Text(
            'Imagen del día y Noticias',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSection(
              title: 'Imagen del día',
              children: [
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
                          _vibrate(); // Activar vibración al tocar el botón
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8)),
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
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
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
              ],
            ),
            SizedBox(height: 16),
            ProfileSection(
              title: 'Noticias',
              children: [
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
                    final noticiaData =
                        noticiaDoc.data() as Map<String, dynamic>;
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
                        _vibrate(); // Activar vibración al tocar el botón
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
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
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final Color containerColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2C2C2E)
        : Color(0xFFFFFFFF);
    final Color shadowColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(177, 255, 22, 22)
        : Colors.black26;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 10.0,
                spreadRadius: 1.9,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
