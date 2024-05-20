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
  bool _vibracionEnabled = false;
  bool _recordatorioEnabled = false;
  bool _sonidoEnabled = false;
  bool _modoNocturnoEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
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
                    setState(() {
                      _vibracionEnabled = !_vibracionEnabled;
                    });
                  },
                  hasSwitch: true,
                  isEnabled: _vibracionEnabled,
                ),
                SizedBox(height: 16),
                ProfileItem(
                  icon: Icons.volume_up,
                  text: 'Sonido',
                  onTap: () {
                    setState(() {
                      _sonidoEnabled = !_sonidoEnabled;
                    });
                  },
                  hasSwitch: true,
                  isEnabled: _sonidoEnabled,
                ),
                SizedBox(height: 16),
                ProfileItem(
                  icon: Icons.nightlight_round,
                  text: 'Modo Nocturno',
                  onTap: () {
                    setState(() {
                      _modoNocturnoEnabled = !_modoNocturnoEnabled;
                    });
                  },
                  hasSwitch: true,
                  isEnabled: _modoNocturnoEnabled,
                ),
                SizedBox(height: 16),
                ProfileItem(
                  icon: Icons.notifications,
                  text: 'Recordatorio',
                  onTap: () {
                    setState(() {
                      _recordatorioEnabled = !_recordatorioEnabled;
                    });
                  },
                  hasSwitch: true,
                  isEnabled: _recordatorioEnabled,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF212121),
            borderRadius: BorderRadius.circular(12),
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
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(text, style: TextStyle(fontSize: 16)),
      trailing: hasSwitch
          ? Switch(
              value: isEnabled,
              onChanged: (_) {
                onTap();
              },
            )
          : Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }
}
