import 'package:astro_app/pagina/review_quiz_page.dart';
import 'package:astro_app/pagina/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

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

  List<String> _backgroundImages = [
    'assets/imagen5.jpg', // Imagen para la sección de cuenta
    'assets/imagen6.jpg', // Imagen para la sección de información
    'assets/imagen4.jpg', // Imagen para la sección de juegos
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(), // Muestra la imagen de fondo según la sección seleccionada
          _buildContentView(),
          _buildContentView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 0, 0),
              Color.fromARGB(255, 255, 0, 0),
              Color.fromARGB(255, 0, 255, 0),
              Color.fromARGB(255, 0, 255, 0),
              Color.fromARGB(255, 0, 0, 255),
              Color.fromARGB(255, 30, 0, 255),
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
          image: AssetImage(_backgroundImages[
              _selectedIndex]), // Accede a la imagen según el índice seleccionado
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContentView() {
    if (_selectedIndex == 0) {
      // Mostrar el widget de perfil en la primera sección
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/perfil.jpg'),
            ),
            SizedBox(height: 40),
            Text(
              'Nombre del admin',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Agregar aquí la lógica para editar el perfil
              },
              child: Text('Editar Perfil'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agregar aquí la lógica para ver el perfil
              },
              child: Text('Ver Perfil'),
            ),
          ],
        ),
      );
    } else if (_selectedIndex == 2) {
      // Mostrar los botones en la sección de "Juegos"
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 70,
              crossAxisSpacing: 30,
              childAspectRatio: 1.2,
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
