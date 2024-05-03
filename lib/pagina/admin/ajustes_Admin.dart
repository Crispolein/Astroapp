import 'package:flutter/material.dart';

class AjustesAdminPage extends StatefulWidget {
  @override
  _AjustesAdminPageState createState() => _AjustesAdminPageState();
}

class _AjustesAdminPageState extends State<AjustesAdminPage> {
  bool recibirNotificaciones = true;

  void cambiarEstadoNotificaciones(bool newValue) {
    setState(() {
      recibirNotificaciones = newValue;
    });
  }

  void irAPaginaIdioma(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaginaSeleccionIdioma()),
    );
  }

  void irAPaginaTema(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaginaSeleccionTema()),
    );
  }

  void borrarDatosUsuario() {
    // Lógica para borrar los datos del usuario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Notificaciones'),
              trailing: Switch(
                value: recibirNotificaciones,
                onChanged: cambiarEstadoNotificaciones,
              ),
            ),
            ListTile(
              title: Text('Idioma'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => irAPaginaIdioma(context),
            ),
            ListTile(
              title: Text('Tema'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => irAPaginaTema(context),
            ),
            ListTile(
              title: Text('Borrar datos'),
              onTap: borrarDatosUsuario,
            ),
            ListTile(
              title: Text('Informacion de la APP'),
              onTap: borrarDatosUsuario,
            ),
            // Otros ajustes...
          ],
        ),
      ),
    );
  }
}

class PaginaSeleccionIdioma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar idioma'),
      ),
      // Contenido de la página de selección de idioma
    );
  }
}

class PaginaSeleccionTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar tema'),
      ),
      // Contenido de la página de selección de tema
    );
  }
}

class InformacionDeLaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion de la APP'),
      ),
      // Contenido de la página de selección de tema
    );
  }
}
