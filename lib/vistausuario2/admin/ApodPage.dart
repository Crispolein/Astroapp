import 'package:flutter/material.dart';
import 'package:astro_app/api/apod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:translator/translator.dart';

class ApodPage extends StatefulWidget {
  const ApodPage({super.key});
  @override
  _ApodPageState createState() => _ApodPageState();
}

class _ApodPageState extends State<ApodPage> {
  late Future<ApodApi> futureApod;
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    futureApod = fetchApod();
  }

  void _mostrarImagenAgrandada(String? imagenURL) {
    if (imagenURL != null) {
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
  }

  Future<void> _descargarImagen(String? imagenURL) async {
    if (imagenURL != null) {
      try {
        var imageId = await ImageDownloader.downloadImage(imagenURL);
        if (imageId == null) {
          return;
        }
        var path = await ImageDownloader.findPath(imageId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagen descargada en: $path')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar la imagen: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('URL de imagen no disponible')),
      );
    }
  }

  Future<String> translateDescription(String description) async {
    var translation = await translator.translate(description, to: 'es');
    return translation.text;
  }

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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final apodData = snapshot.data;
                          return GestureDetector(
                            onTap: () {
                              _mostrarImagenAgrandada(apodData?.hdurl);
                            },
                            onLongPress: () {
                              _descargarImagen(apodData?.hdurl);
                            },
                            child: Column(
                              children: [
                                if (apodData?.hdurl != null)
                                  Image.network(
                                    apodData!.hdurl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    apodData?.title ?? 'Título no disponible',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: Text('No data available'));
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<ApodApi>(
                      future: futureApod,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final apodData = snapshot.data;
                          return FutureBuilder<String>(
                            future: translateDescription(
                                apodData?.explanation ?? ''),
                            builder: (context, translateSnapshot) {
                              if (translateSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (translateSnapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Error: ${translateSnapshot.error}'));
                              } else if (translateSnapshot.hasData) {
                                return Text(
                                  translateSnapshot.data ??
                                      'Descripción no disponible',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else {
                                return Center(
                                    child: Text('No translation available'));
                              }
                            },
                          );
                        } else {
                          return Center(child: Text('No data available'));
                        }
                      },
                    ),
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
