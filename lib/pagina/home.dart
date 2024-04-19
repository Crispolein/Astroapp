import 'package:astro_app/pagina/review_quiz_page.dart';
import 'package:astro_app/pagina/quiz_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Aquí se oculta la etiqueta de debug
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const QuizPage()));
                // Aquí puedes agregar la lógica para iniciar el quiz
              },
              child: Text('Iniciar Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReviewQuizPage()));
              },
              child: Text('Repasar Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
