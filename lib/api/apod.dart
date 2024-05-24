import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApodApi {
  final String? title;
  final String? explanation;
  final String? hdurl;
  final String? type;
  final String? copyright;

  ApodApi({
    this.title,
    this.explanation,
    this.hdurl,
    this.type,
    this.copyright,
  });

  factory ApodApi.fromJson(Map<String, dynamic> json) {
    return ApodApi(
      title: json['title'] as String?,
      explanation: json['explanation'] as String?,
      hdurl: json['url'] as String?,
      type: json['media_type'] as String?,
      copyright: json['copyright'] as String?,
    );
  }
}

Future<ApodApi> fetchApod() async {
  try {
    var response = await http.get(Uri.parse(
        "https://api.nasa.gov/planetary/apod?api_key=rgjdbcX24SLIQ6IO9eup4x3tezKgecjxa514kH7Y"));

    if (response.statusCode == 200) {
      return ApodApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load JSON');
    }
  } on SocketException catch (_) {
    throw Exception('Failed to load JSON');
  }
}
