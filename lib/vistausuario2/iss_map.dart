import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ISSData extends StatefulWidget {
  @override
  _ISSDataState createState() => _ISSDataState();
}

class _ISSDataState extends State<ISSData> {
  LatLng _issPosition = LatLng(0, 0);
  MapController _mapController = MapController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchISSData();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchISSData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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

          // ignore: deprecated_member_use
          _mapController.move(_issPosition, _mapController.zoom);
        });
      } else {
        print(
            'Error fetching ISS data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Network error fetching ISS data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('International Space Station Tracker'),
        automaticallyImplyLeading: false,
      ),
      body: FlutterMap(
        mapController: _mapController,
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
                child: Image.asset(
                  'assets/spacecraft.png',
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
