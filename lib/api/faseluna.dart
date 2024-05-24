import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:astro_app/models/proyecto_model.dart';

Future<List<FaseLunar>> fetchFasesLunares(
    String latitude, String longitude, String startDate, String endDate) async {
  final String apiKey = "e1687554-4196-40bb-a612-0fff9c1588fd	";

  try {
    var response = await http.get(
      Uri.parse(
          'https://api.astronomyapi.com/api/v2/bodies/positions/moon?latitude=$latitude&longitude=$longitude&from_date=$startDate&to_date=$endDate'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonList =
          json.decode(response.body)['data']['table']['rows'];
      return jsonList
          .map((json) => FaseLunar.fromJson(json['cells'][0]))
          .toList();
    } else {
      throw Exception('Failed to load JSON: ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load JSON: $e');
  } catch (e) {
    throw Exception('Failed to load JSON: $e');
  }
}
