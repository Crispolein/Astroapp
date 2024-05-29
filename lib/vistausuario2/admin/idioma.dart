import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  void _changeLanguage(Locale locale) {
    context.setLocale(locale);
    setState(() {
      // This will trigger a rebuild of the widget
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF1C1C1E)
            : Color.fromARGB(255, 255, 255, 255);
    final Color buttonColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.amber
        : Colors.grey[800]!;
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[300]!
        : Colors.white;
    final Color appBarColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1C1C1E)
        : Color.fromARGB(255, 255, 255, 255);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Seleccionar Idioma')),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LanguageButton(
              text: 'Español',
              onPressed: () {
                _changeLanguage(Locale('es'));
              },
              buttonColor: buttonColor,
              textColor: textColor,
            ),
            SizedBox(height: 16),
            LanguageButton(
              text: 'Japonés',
              onPressed: () {
                _changeLanguage(Locale('ja'));
              },
              buttonColor: buttonColor,
              textColor: textColor,
            ),
            SizedBox(height: 16),
            LanguageButton(
              text: 'English',
              onPressed: () {
                _changeLanguage(Locale('en'));
              },
              buttonColor: buttonColor,
              textColor: textColor,
            ),
            SizedBox(height: 16),
            LanguageButton(
              text: 'Português',
              onPressed: () {
                _changeLanguage(Locale('pt'));
              },
              buttonColor: buttonColor,
              textColor: textColor,
            ),
            SizedBox(height: 16),
            LanguageButton(
              text: 'Alemán',
              onPressed: () {
                _changeLanguage(Locale('de'));
              },
              buttonColor: buttonColor,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;

  const LanguageButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.0),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0, color: textColor),
        ),
      ),
    );
  }
}
