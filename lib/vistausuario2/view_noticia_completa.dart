import 'package:astro_app/models/proyecto_model.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración

class NoticiaCompletaPage extends StatelessWidget {
  final Noticia noticia;

  const NoticiaCompletaPage({Key? key, required this.noticia})
      : super(key: key);

  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(
          duration: 50); // Duración de la vibración en milisegundos
    }
  }

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
        title: Text(noticia.titulo,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _vibrate(); // Activar vibración al tocar la imagen
                  if (noticia.imagenURL.isNotEmpty) {
                    _mostrarImagenAgrandada(context, noticia.imagenURL);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
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
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700),
              ),
              SizedBox(height: 8),
              Divider(color: Colors.teal.shade200),
              Text(
                noticia.descripcion,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
