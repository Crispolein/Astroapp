import 'package:astro_app/vistausuario2/PerfilbPage.dart';
import 'package:astro_app/vistausuario2/categoria.dart';
import 'package:astro_app/vistausuario2/luna.dart' as user;
import 'package:astro_app/vistausuario2/noticias.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:astro_app/vistausuario2/iss_map.dart';
import 'package:vibration/vibration.dart'; // Importa el paquete de vibración

class HomebPage extends StatefulWidget {
  @override
  _HomebPageState createState() => _HomebPageState();
}

class _HomebPageState extends State<HomebPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PerfilbPage(),
    NoticiasPage(),
    CategoriaPage(),
    user.FaseLunarPage(),
    ISSData(),
  ];

  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(
          duration: 50); // Duración de la vibración en milisegundos
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _vibrate(); // Activar vibración al tocar el botón
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
          FlashyTabBarItem(
            icon: Icon(Icons.image,
                size: 35, color: const Color.fromARGB(255, 0, 0, 0)),
            title: Text('ISS Info',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 17)),
          ),
        ],
      ),
    );
  }
}
