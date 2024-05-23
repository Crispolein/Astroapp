import 'package:flutter/material.dart';
import 'package:astro_app/api/apod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Asegúrate de tener esta dependencia
import 'package:image_downloader/image_downloader.dart';

class ApodPage extends StatefulWidget {
  const ApodPage({super.key});
  @override
  _ApodPageState createState() => _ApodPageState();
}

class _ApodPageState extends State<ApodPage> {
  late Future<ApodApi> futureApod;

  @override
  void initState() {
    super.initState();
    futureApod = fetchApod();
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
              child: Image.network(imagenURL),
            ),
          ),
        );
      },
    );
  }

  Future<void> _descargarImagen(String imagenURL) async {
    try {
      // Descarga y guarda la imagen en el dispositivo
      var imageId = await ImageDownloader.downloadImage(imagenURL);
      if (imageId == null) {
        return;
      }
      // Obtén la ruta del archivo descargado
      var path = await ImageDownloader.findPath(imageId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen descargada en: $path')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar la imagen: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12.0), // Espacio horizontal
          child: Icon(Icons.menu),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0), // Espacio horizontal
            child: Icon(FontAwesomeIcons.globe), // Icono de planeta
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
            Container(
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
                    child: FutureBuilder<ApodApi>(
                      future: futureApod,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: () {
                              _mostrarImagenAgrandada(snapshot.data!.hdurl);
                            },
                            onLongPress: () {
                              _descargarImagen(snapshot.data!.hdurl);
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  snapshot.data!.hdurl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      200, // Ajusta la altura según sea necesario
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data!.title,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<ApodApi>(
                      future: futureApod,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!.explanation,
                            style: TextStyle(color: Colors.white),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(height: 8),
            Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
