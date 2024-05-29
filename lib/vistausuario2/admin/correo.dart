import 'package:flutter/material.dart';

class CasillaDeCorreoPage extends StatefulWidget {
  @override
  _CasillaDeCorreoPageState createState() => _CasillaDeCorreoPageState();
}

class _CasillaDeCorreoPageState extends State<CasillaDeCorreoPage> {
  String _email = '';

  void _updateEmail(String email) {
    setState(() {
      _email = email;
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
        title: Text('Casilla de Correo'),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
              child: TextField(
                onChanged: _updateEmail,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
              ),
            ),
            SizedBox(height: 30.0),
            Center(
              child: SizedBox(
                width: 200, // Tamaño adecuado para el botón
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí puedes manejar el envío del correo electrónico
                    print('Correo enviado: $_email');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: Text(
                    'Enviar',
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
