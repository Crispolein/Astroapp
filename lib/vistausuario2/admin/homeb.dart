import 'package:astro_app/vistausuario2/admin/CrearYeditarA/categoria.dart';
import 'package:astro_app/vistausuario2/admin/PerfilbPage.dart';
import 'package:astro_app/vistausuario2/admin/Noticia/noticia.dart';
import 'package:astro_app/vistausuario2/admin/theme.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

class HomeadminPage extends StatefulWidget {
  @override
  _HomeadminPageState createState() => _HomeadminPageState();
}

class _HomeadminPageState extends State<HomeadminPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PerfiladministradorPage(),
    NoticiasadminPage(),
    CategoriaadminPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        final bool isDarkMode = themeNotifier.value == ThemeMode.dark;
        final Color backgroundColor =
            isDarkMode ? Colors.blueGrey : Colors.white;
        final Color selectedColor =
            isDarkMode ? Colors.black : const Color.fromRGBO(165, 121, 68, 1);
        final Color unselectedColor = isDarkMode ? Colors.grey : Colors.black;

        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.value,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _pages[_selectedIndex],
            ),
            bottomNavigationBar: FlashyTabBar(
              selectedIndex: _selectedIndex,
              backgroundColor: backgroundColor,
              animationCurve: Curves.linear,
              animationDuration: Duration(milliseconds: 300),
              showElevation: true,
              onItemSelected: _onItemTapped,
              items: [
                FlashyTabBarItem(
                  icon: Icon(Icons.person, size: 35, color: selectedColor),
                  title: Text('Perfil',
                      style: TextStyle(color: selectedColor, fontSize: 17)),
                ),
                FlashyTabBarItem(
                  icon: Icon(Icons.article, size: 35, color: selectedColor),
                  title: Text('Noticias',
                      style: TextStyle(color: selectedColor, fontSize: 17)),
                ),
                FlashyTabBarItem(
                  icon: Icon(Icons.games, size: 35, color: selectedColor),
                  title: Text('Juegos',
                      style: TextStyle(color: selectedColor, fontSize: 17)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(
    AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.value,
          debugShowCheckedModeBanner: false,
          home: HomeadminPage(),
        );
      },
    ),
  );
}
