import 'package:astro_app/vistausuario2/admin/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagina de Usuario',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
      ),
      home: AjustesadminPage(),
    );
  }
}
class AjustesadminPage extends StatefulWidget {
  @override
  _AjustesadminPageState createState() => _AjustesadminPageState();
}

class _AjustesadminPageState extends State<AjustesadminPage> {
  bool _modoNocturnoEnabled = false;
  Color _appBarColor = Colors.transparent; // Initial transparent color

  void _toggleTheme() {
    setState(() {
      _modoNocturnoEnabled = !_modoNocturnoEnabled;
      themeNotifier.toggleTheme();
      _updateAppBarColor(); // Update AppBar color based on theme change
    });
  }

  void _updateAppBarColor() {
    _appBarColor = themeNotifier.value == ThemeMode.dark
        ? Color(0xFF1C1C1E) // Dark theme color
        : Color.fromARGB(255, 255, 255, 255); // Light theme color
  }

  @override
  void initState() {
    super.initState();
    _updateAppBarColor(); // Update AppBar color on initial load
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 1500), // Slower transition
      child: Scaffold(
        key: ValueKey<bool>(
            _modoNocturnoEnabled), // Key to trigger the animation
        backgroundColor: themeNotifier.value == ThemeMode.dark
            ? Color(0xFF1C1C1E)
            : Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: Text('Ajustes'),
          backgroundColor: _appBarColor, // Set dynamic AppBar color
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 32),
              ProfileSection(
                title: '',
                children: [
                  ProfileItem(
                    icon: Icons.vibration,
                    text: 'Vibración',
                    onTap: () {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  ProfileItem(
                    icon: Icons.volume_up,
                    text: 'Sonido',
                    onTap: () {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  ProfileItem(
                    icon: Icons.nightlight_round,
                    text: 'Modo Nocturno',
                    onTap: _toggleTheme,
                    hasSwitch: true,
                    isEnabled: _modoNocturnoEnabled,
                  ),
                  SizedBox(height: 16),
                  ProfileItem(
                    icon: Icons.notifications,
                    text: 'Recordatorio',
                    onTap: () {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  ProfileItem(
                    icon: Icons.color_lens,
                    text: 'Color',
                    onTap: () {
                      // Acción al tocar el botón de color
                    },
                  ),
                  SizedBox(height: 16),
                  ProfileItem(
                    icon: Icons.format_paint,
                    text: 'Estilo de letra',
                    onTap: () {
                      // Acción al tocar el botón de estilo de letra
                    },
                  ),
                  SizedBox(height: 16),
                  ProfileItem(
                    icon: Icons.headset_mic,
                    text: 'Soporte',
                    onTap: () {
                      // Acción al tocar el botón de soporte
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar el color del contenedor basado en el modo de tema
    final Color containerColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2C2C2E)
        : Color(0xFFFFFFFF);

    final Color shadowColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(177, 255, 22, 22)
        : Colors.black26;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 10.0,
                spreadRadius: 1.9,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool hasSwitch;
  final bool isEnabled;

  const ProfileItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.hasSwitch = false,
    this.isEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar el color del icono y la flecha basado en el modo de tema
    final Color iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.orange
        : Color(0xFFF8E24AA);
    final Color arrowColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : Colors.black;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text, style: TextStyle(fontSize: 16)),
      trailing: hasSwitch
          ? Switch(
              value: isEnabled,
              onChanged: (_) {
                onTap();
              },
            )
          : Icon(Icons.arrow_forward_ios, color: arrowColor),
      onTap: onTap,
    );
  }
}

