import 'package:astro_app/pagina/review_quiz_page.dart';
import 'package:astro_app/pagina/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_selectedIndex == 2)
            _buildBackgroundImage(), // Solo muestra la imagen de fondo en la sección de "Juegos"
          _buildContentView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 134, 160, 255),
              Color.fromARGB(255, 255, 0, 0),
              Color.fromARGB(255, 0, 255, 0),
              Color.fromARGB(255, 0, 0, 255),
              Color.fromARGB(255, 255, 255, 0),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: CurvedNavigationBar(
          color: Colors.blue,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            Icon(Icons.account_circle, size: 30),
            Icon(Icons.info, size: 30),
            Icon(Icons.sports_esports, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imagen4.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContentView() {
    if (_selectedIndex == 2) {
      // Solo muestra los botones en la sección de "Juegos"
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.9, // Ancho del container
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 70,
              crossAxisSpacing: 30,
              childAspectRatio:
                  1.2, // Relación de aspecto para controlar el tamaño de los cuadrados
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuizPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Cambia el color del botón
                    padding: EdgeInsets.all(
                        20), // Ajusta el espacio dentro del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Iniciar Quiz',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReviewQuizPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Cambia el color del botón
                    padding: EdgeInsets.all(
                        20), // Ajusta el espacio dentro del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Repasar Quiz',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReviewQuizPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cambia el color del botón
                    padding: EdgeInsets.all(
                        20), // Ajusta el espacio dentro del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'juego 3',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReviewQuizPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Cambia el color del botón
                    padding: EdgeInsets.all(
                        20), // Ajusta el espacio dentro del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'juego 4',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReviewQuizPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 32, 241, 227), // Cambia el color del botón
                    padding: EdgeInsets.all(
                        20), // Ajusta el espacio dentro del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'juego 5',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReviewQuizPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 255, 49, 231), // Cambia el color del botón
                    padding: EdgeInsets.all(
                        20), // Ajusta el espacio dentro del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'juego 6',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(); // Oculta el contenido en las secciones diferentes a "Juegos"
    }
  }
}
