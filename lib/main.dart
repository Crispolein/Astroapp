import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AstroApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Flutter Demo'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            icon: Icon(Icons.login),
          ),
        ],
      ),
      body: Placeholder(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.article),
              tooltip: 'Noticias',
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.sports_esports),
              tooltip: 'Juegos',
            ),
            CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Text(
                '?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.today),
              tooltip: '¿Que acontece hoy?',
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.image),
              tooltip: 'Imagen del día',
            ),
          ],
        ),
      ),
    );
  }
}
