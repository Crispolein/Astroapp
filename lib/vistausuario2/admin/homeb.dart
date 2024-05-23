import 'package:astro_app/pagina/usuario/view_apod.dart';
import 'package:astro_app/vistausuario2/admin/PerfilbPage.dart';
import 'package:astro_app/vistausuario2/admin/categoria.dart';
import 'package:astro_app/vistausuario2/admin/luna.dart';
import 'package:astro_app/vistausuario2/admin/Noticia/noticia.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:astro_app/vistausuario2/admin/ApodPage.dart' as admin;

class HomeadminPage extends StatefulWidget {
  @override
  _HomeadminPageState createState() => _HomeadminPageState();
}

class _HomeadminPageState extends State<HomeadminPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PerfiladministradorPage(),
    //PerfilbPage(),
    NoticiasadminPage(),
    CategoriaadminPage(),
    FaselunaradminPage(),
    admin.ApodPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_selectedIndex],
      ),
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
            title: Text('Imagen',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 17)),
          ),
        ],
      ),
    );
  }
}
