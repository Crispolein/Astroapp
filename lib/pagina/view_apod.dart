import 'package:flutter/material.dart';
import 'package:astro_app/api/apod.dart';

class ApodPage extends StatefulWidget {
  const ApodPage({super.key});

  @override
  _ApodPageState createState() => _ApodPageState();
}

class _ApodPageState extends State<ApodPage> {
  late Future<ApodApi> futureApod;

  @override
  void initState() {
    super.initState();
    futureApod = fetchApod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagen del día'),
      ),
      body: Center(
        child: FutureBuilder<ApodApi>(
          future: futureApod,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    snapshot.data!.title,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Image.network(
                    snapshot.data!.hdurl,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    snapshot.data!.explanation,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // Mientras se carga la imagen
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
