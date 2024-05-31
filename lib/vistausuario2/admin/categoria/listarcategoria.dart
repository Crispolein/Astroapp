import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/vistausuario2/admin/categoria/crearcategoria.dart';
import 'package:astro_app/vistausuario2/admin/categoria/editarcategoria.dart';

class ListaCategorias extends StatefulWidget {
  @override
  _ListaCategoriasState createState() => _ListaCategoriasState();
}

class _ListaCategoriasState extends State<ListaCategorias> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newCategory = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NuevaCategoria()),
              );
              if (newCategory != null) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('categoria').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredCategories = snapshot.data!.docs.where((doc) {
                  final category = doc['categoria'].toString().toLowerCase();
                  return category.contains(_searchText.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];

                    return ListTile(
                      title: Text(category['categoria']),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final updatedCategory = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarCategoria(
                                categoria: Categoria(
                                  id: category.id,
                                  categoria: category['categoria'],
                                ),
                              ),
                            ),
                          );
                          if (updatedCategory != null) {
                            setState(() {});
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
