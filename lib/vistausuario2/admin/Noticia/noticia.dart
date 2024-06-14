import 'package:astro_app/vistausuario2/admin/Noticia/agregarnoticia.dart';
import 'package:astro_app/vistausuario2/admin/Noticia/listarnoticia.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Página de Noticias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoticiasadminPage(),
    );
  }
}

class NoticiasadminPage extends StatelessWidget {
  const NoticiasadminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Para quitar la flecha de retroceso
        title: const Text(
          'Últimas Noticias',
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.amber, // Color naranja
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNoticia()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 120,
                  color: Colors.purple,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Agregar Noticia',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListarNoticia(
                              elemento: '',
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 120,
                  color: Colors.purple,
                ),
              ),
            ),
            SizedBox(height: 10),
            const Text(
              'Editar Noticia',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
