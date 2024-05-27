import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FaseLunar {
  final String fecha;
  final String imagen;

  FaseLunar({
    required this.fecha,
    required this.imagen,
  });

  factory FaseLunar.fromJson(Map<String, dynamic> json) {
    return FaseLunar(
      fecha: json['date'] as String,
      imagen: json['imageUrl'] as String,
    );
  }
}

Future<FaseLunar> fetchMoonPhase(
    String latitude, String longitude, String date) async {
  final String apiKey =
      "86ab6c1a-9f55-405d-942f-a7959bc94feb"; // Reemplaza con tu clave API

  try {
    var response = await http.post(
      Uri.parse('https://api.astronomyapi.com/api/v2/studio/moon-phase'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'format': 'png',
        'style': {
          'moonStyle':
              'default', // Puedes cambiar esto según el estilo que desees
          'backgroundStyle': 'stars',
          'backgroundColor': 'black',
          'headingColor': 'white',
          'textColor': 'white',
        },
        'observer': {
          'latitude': latitude,
          'longitude': longitude,
          'date': date,
        },
        'view': {
          'type':
              'portrait-simple', // Puedes cambiar esto según el tipo de vista que desees
        }
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return FaseLunar.fromJson(
          {'date': date, 'imageUrl': jsonResponse['data']['imageUrl']});
    } else {
      throw Exception('Failed to load JSON: ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load JSON: $e');
  } catch (e) {
    throw Exception('Failed to load JSON: $e');
  }
}
