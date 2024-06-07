import 'package:astro_app/models/proyecto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:astro_app/vistausuario2/admin/Noticia/editarnoticia.dart';

class ListarNoticia extends StatefulWidget {
  const ListarNoticia({Key? key, required String elemento}) : super(key: key);
  @override
  _ListarNoticiaState createState() => _ListarNoticiaState();
}

class _ListarNoticiaState extends State<ListarNoticia> {
  final CollectionReference noticiaCollection =
      FirebaseFirestore.instance.collection('noticia');
  String _filtroTexto = '';

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

  void _eliminarNoticia(String noticiaId) async {
    await noticiaCollection.doc(noticiaId).delete();
    setState(() {});
  }

  void _confirmarEliminacion(String noticiaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta noticia?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                _eliminarNoticia(noticiaId);
              },
            ),
          ],
        );
      },
    );
  }

  void _editarNoticia(Noticia noticia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarNoticiaPage(
          noticia: noticia,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Filtrar por título o categoría',
                      prefixIcon: const Icon(Icons.search),
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
              final categoria = noticiaData['categoria'] ?? '';
              return titulo
                      .toLowerCase()
                      .contains(_filtroTexto.toLowerCase()) ||
                  categoria.toLowerCase().contains(_filtroTexto.toLowerCase());
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
                    categoria: noticiaData['categoria'] ?? '',
                    titulo: noticiaData['titulo'] ?? '',
                    descripcion: noticiaData['descripcion'] ?? '',
                    imagenURL: noticiaData['imagenURL'] ?? '',
                    timestamp: noticiaData['timestamp'] ?? Timestamp.now(),
                  );
                  return Card(
                    child: ListTile(
                      title: Text(
                        noticia.titulo,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categoría: ${noticia.categoria}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
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
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editarNoticia(noticia);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _confirmarEliminacion(noticia.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
