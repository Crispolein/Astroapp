import 'package:astro_app/pagina/usuario/ajustes.dart';
import 'package:astro_app/pagina/usuario/editar_perfil.dart';
import 'package:astro_app/pagina/quiz_page.dart';
import 'package:astro_app/pagina/review_quiz_page.dart';
import 'package:astro_app/vistausuario2/PerfilPage.dart';
import 'package:astro_app/vistausuario2/PerfilbPage.dart';
import 'package:astro_app/vistausuario2/categoria.dart';
import 'package:astro_app/vistausuario2/gei.dart';
import 'package:astro_app/vistausuario2/luna.dart' as user;
import 'package:astro_app/vistausuario2/admin/usuario/noticias.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// Importa la biblioteca donde se encuentra fase_lunar.dart
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

class HomebPage extends StatefulWidget {
  @override
  _HomebPageState createState() => _HomebPageState();
}

class _HomebPageState extends State<HomebPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PerfilbPage(),
    //PerfilPage(),
    //HomeScreen(),
    //GeiPage(),
    NoticiasPage(),
    CategoriaPage(),
    user.FaseLunarPage(),
    PerfilbPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.blueGrey,
        animationCurve: Curves.linear,
        animationDuration: Duration(milliseconds: 300),
        showElevation: true,
        onItemSelected: _onItemTapped,
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.person,
                size: 35, color: const Color.fromARGB(255, 0, 0, 0)),
            title: Text('Perfil',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 17)),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.home,
                size: 35, color: const Color.fromARGB(255, 0, 0, 0)),
            title: Text('Inicio',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 17)),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.games,
                size: 35, color: const Color.fromARGB(255, 0, 0, 0)),
            title: Text('Juegos',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 17)),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.brightness_2,
                size: 35, color: const Color.fromARGB(255, 0, 0, 0)),
            title: Text('Lunas',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 17)),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Bienvenido a la página de inicio',
            style: TextStyle(fontSize: 24.0),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnotherPage()),
              );
            },
            child: Text('Ir a otra página'),
          ),
        ],
      ),
    );
  }
}

class AnotherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Otra Página'),
      ),
      body: Center(
        child: Text('Esta es otra página'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomebPage(),
  ));
}
