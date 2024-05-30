import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import for Timer

class ISSData extends StatefulWidget {
  @override
  _ISSDataState createState() => _ISSDataState();
}

class _ISSDataState extends State<ISSData> {
  LatLng _issPosition = LatLng(0, 0);
  Timer? _timer; // Add a timer for periodic updates

  @override
  void initState() {
    super.initState();
    _fetchISSData();
    // Start the timer for updating every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchISSData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _fetchISSData() async {
    try {
      final response =
          await http.get(Uri.parse('http://api.open-notify.org/iss-now.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _issPosition = LatLng(
            double.parse(data['iss_position']['latitude']),
            double.parse(data['iss_position']['longitude']),
          );
        });
      } else {
        // Log an error if the request was not successful
        print(
            'Error fetching ISS data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Catch and log any network errors
      print('Network error fetching ISS data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('International Space Station Tracker'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _issPosition,
          zoom: 3.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _issPosition,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
