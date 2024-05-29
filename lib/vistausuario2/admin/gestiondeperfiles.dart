import 'package:flutter/material.dart';

class GestionDePerfilesPage extends StatefulWidget {
  @override
  _GestionDePerfilesPageState createState() => _GestionDePerfilesPageState();
}

class _GestionDePerfilesPageState extends State<GestionDePerfilesPage> {
  List<String> _profiles = ['Usuario 1', 'Usuario 2', 'Usuario 3'];

  void _addProfile() {
    setState(() {
      _profiles.add('Nuevo Usuario');
    });
  }

  void _editProfile(int index, String newName) {
    setState(() {
      _profiles[index] = newName;
    });
  }

  void _deleteProfile(int index) {
    setState(() {
      _profiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1C1C1E)
        : Color.fromARGB(255, 255, 255, 255);
    final Color cardColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2C2C2E)
        : Color(0xFFFFFFFF);
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[300]!
        : Colors.black;
    final Color appBarColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1C1C1E)
        : Color.fromARGB(255, 255, 255, 255);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Perfiles'),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _profiles.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        _profiles[index],
                        style: TextStyle(color: textColor),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.amber),
                            onPressed: () {
                              _showEditProfileDialog(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteProfile(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: Text(
                  'Agregar Perfil',
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(int index) {
    TextEditingController controller = TextEditingController();
    controller.text = _profiles[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Perfil'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Nombre del Perfil',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editProfile(index, controller.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Guardar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
