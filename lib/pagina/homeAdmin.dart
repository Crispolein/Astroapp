import 'package:astro_app/Login/login_page.dart';
import 'package:astro_app/pagina/admin/ajustes_Admin.dart';
import 'package:astro_app/pagina/admin/editar_perfil_Admin.dart';
import 'package:astro_app/pagina/quiz_page.dart';
import 'package:astro_app/pagina/review_quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// Importa la biblioteca donde se encuentra fase_lunar.dart
import 'fase_lunar.dart';

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

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: const Center(
        child: Text('Contenido del perfil aquí'),
      ),
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
          _buildBackgroundImage(),
          _buildContentView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
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
          items: const <Widget>[
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
          image: AssetImage(_backgroundImages[_selectedIndex]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContentView() {
    if (_selectedIndex == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/perfil.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditarAdminPerfil()),
                );
              },
              child: Text('Editar perfil'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Menos redondez
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditarAdminPerfil()),
                );
              },
              child: Text('Ver Perfil'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Menos redondez
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjustesAdminPage()),
                );
              },
              child: Text('Ajustes'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Menos redondez
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjustesAdminPage()),
                );
              },
              child: Text('Gestion De Perfiles'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Menos redondez
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjustesAdminPage()),
                );
              },
              child: Text('Casilla de Correos'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Menos redondez
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Menos redondez
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_selectedIndex == 1) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FaseLunar(),
              ),
            );
          },
          child: const Text('Ir a Fase Lunar'),
        ),
      );
    } else if (_selectedIndex == 2) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
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
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
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
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
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
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
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
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
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
                    backgroundColor: Color.fromARGB(255, 32, 241, 227),
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
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
                    backgroundColor: Color.fromARGB(255, 255, 49, 231),
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
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
      return Container();
    }
  }
}
