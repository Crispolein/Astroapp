import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/router/router.dart';
import 'package:astro_app/router/router_config.dart';
import 'package:go_router/go_router.dart';

class ListarNoticia extends StatefulWidget {
  const ListarNoticia({Key? key, required String elemento}) : super(key: key);
  @override
  _ListarNoticiaState createState() => _ListarNoticiaState();
}

class _ListarNoticiaState extends State<ListarNoticia> {
  final CollectionReference noticiaCollection =
      FirebaseFirestore.instance.collection('noticia');
  int? _filtroNoticia;
  String _filtroTexto = '';

  Future<void> _confirmarEliminar(String id) async {
    final confirmado = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Noticia'),
          content: const Text('¿Estás seguro de eliminar esta noticia?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );

    if (confirmado) {
      await noticiaCollection.doc(id).delete();
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
        title: const Text('Noticias'),
        actions: const [],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Filtrar por noticia',
                      prefixIcon: _filtroNoticia != null
                          ? const Icon(Icons.filter_alt_rounded,
                              color: Colors.amber)
                          : const Icon(Icons.filter_alt_rounded),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filtroTexto = value;
                      });
                    },
                  ),
                ),
              ),
            ],
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
              return titulo.toLowerCase().contains(_filtroTexto.toLowerCase());
            }).toList();
            return ListView.separated(
                itemCount: noticiaDocs.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (context, index) {
                  final noticiaDoc = noticiaDocs[index];
                  final noticiaData = noticiaDoc.data() as Map<String, dynamic>;
                  final noticia = Noticia(
                    id: noticiaDoc.id,
                    titulo: noticiaData['titulo'] ?? '',
                    descripcion: noticiaData['descripcion'] ?? '',
                    imagenURL: noticiaData['imagenURL'] ?? '',
                  );
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${noticia.titulo}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Titulo: ${noticia.titulo}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Descripcion: ${noticia.descripcion}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      leading: GestureDetector(
                        onTap: () {
                          if (noticia.imagenURL.isNotEmpty) {
                            _mostrarImagenAgrandada(noticia.imagenURL);
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: noticia.imagenURL.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(noticia.imagenURL),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                GoRouter.of(context).pushNamed(
                                  Routers.editarnoticia.name,
                                );
                              }),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmarEliminar(noticiaDoc.id),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoRouter.of(context).pushNamed(
            Routers.addnoticia.name,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
