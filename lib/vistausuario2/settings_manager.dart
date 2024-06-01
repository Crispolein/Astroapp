import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String vibracionKey = 'vibracionEnabled';
  static const String sonidoKey = 'sonidoEnabled';
  static const String modoNocturnoKey = 'modoNocturnoEnabled';
  static const String recordatorioKey = 'recordatorioEnabled';

  static Future<void> setVibracionEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(vibracionKey, value);
  }

  static Future<bool> getVibracionEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(vibracionKey) ?? false;
  }

  static Future<void> setSonidoEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(sonidoKey, value);
  }

  static Future<bool> getSonidoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sonidoKey) ?? false;
  }

  static Future<void> setModoNocturnoEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(modoNocturnoKey, value);
  }

  static Future<bool> getModoNocturnoEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(modoNocturnoKey) ?? false;
  }

  static Future<void> setRecordatorioEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(recordatorioKey, value);
  }

  static Future<bool> getRecordatorioEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(recordatorioKey) ?? false;
  }
}
