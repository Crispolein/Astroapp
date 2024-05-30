import 'package:astro_app/models/proyecto_model.dart';
import 'package:flutter/material.dart';

class NoticiaCompletaPage extends StatelessWidget {
  final Noticia noticia;

  const NoticiaCompletaPage({Key? key, required this.noticia})
      : super(key: key);

  void _mostrarImagenAgrandada(BuildContext context, String imagenURL) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noticia.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (noticia.imagenURL.isNotEmpty) {
                  _mostrarImagenAgrandada(context, noticia.imagenURL);
                }
              },
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
                        size: 100,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Categoría: ${noticia.categoria}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              noticia.descripcion,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
