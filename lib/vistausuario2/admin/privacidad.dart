import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz de Astronomía',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1C1C1E),
      ),
      home: PrivacyPolicyadminPage(),
    );
  }
}

class PrivacyPolicyadminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Políticas de Privacidad'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Políticas de Privacidad',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Introducción',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'En nuestro Quiz de Astronomía, valoramos tu privacidad. Esta política de privacidad explica cómo recopilamos, usamos y protegemos tu información personal.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Información que Recopilamos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Recopilamos la siguiente información cuando utilizas nuestro quiz:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- Información de contacto: nombre, dirección de correo electrónico.\n- Datos de uso: respuestas a las preguntas del quiz, puntuaciones y estadísticas de uso.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Uso de la Información',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Usamos la información recopilada para los siguientes propósitos:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- Mejorar la experiencia del usuario y el contenido del quiz.\n- Enviar notificaciones relacionadas con el quiz, si has optado por recibirlas.\n- Analizar el uso y rendimiento del quiz.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Protección de la Información',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Implementamos medidas de seguridad para proteger tu información personal. Sin embargo, ninguna medida de seguridad es perfecta o impenetrable, y no podemos garantizar la seguridad absoluta de tu información.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Compartir Información',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'No compartimos tu información personal con terceros, excepto en las siguientes circunstancias:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '- Con tu consentimiento explícito.\n- Para cumplir con leyes o regulaciones aplicables.\n- Para proteger nuestros derechos, propiedad o seguridad, o los de otros.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Cambios en la Política de Privacidad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Nos reservamos el derecho de actualizar esta política de privacidad en cualquier momento. Te notificaremos sobre cualquier cambio publicando la nueva política de privacidad en esta página.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contacto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Si tienes alguna pregunta o inquietud sobre esta política de privacidad, por favor contáctanos a través de nuestro correo electrónico: contacto@quizdeastronomia.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
