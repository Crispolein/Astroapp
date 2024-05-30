import 'dart:convert';
import 'package:http/http.dart' as http;

class IssService {
  final String apiUrl = "http://api.open-notify.org/iss-now.json";

  Future<Map<String, dynamic>> fetchIssPosition() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load ISS position');
    }
  }
}
