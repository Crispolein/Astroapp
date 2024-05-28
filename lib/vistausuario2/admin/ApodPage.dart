import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translator/translator.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:astro_app/api/apod.dart';
import 'package:intl/intl.dart';

class ApodPage extends StatefulWidget {
  const ApodPage({super.key});
  @override
  _ApodPageState createState() => _ApodPageState();
}

class _ApodPageState extends State<ApodPage> {
  late Future<ApodApi> futureApod;
  final translator = GoogleTranslator();
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    futureApod = fetchApod(date: DateFormat('yyyy-MM-dd').format(selectedDate));
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  void _mostrarImagenAgrandada(String? imagenURL) {
    if (imagenURL != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Image.network(imagenURL),
              ),
            ),
          );
        },
      );
    }
  }

  Future<String> translateDescription(String description) async {
    var translation = await translator.translate(description, to: 'es');
    return translation.text;
  }

  void _navigateDate(int days) {
    final newDate = selectedDate.add(Duration(days: days));
    if (newDate.isAfter(DateTime.now())) {
      return; // No permitir fechas futuras
    }
    setState(() {
      selectedDate = newDate;
      futureApod =
          fetchApod(date: DateFormat('yyyy-MM-dd').format(selectedDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _navigateDate(-1),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => _navigateDate(1),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(FontAwesomeIcons.globe),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Imagen del día',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange[800],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(8)),
                      child: FutureBuilder<ApodApi>(
                        future: futureApod,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final apodData = snapshot.data;
                            if (apodData?.type == 'image') {
                              return GestureDetector(
                                onTap: () {
                                  _mostrarImagenAgrandada(apodData?.url);
                                },
                                child: Column(
                                  children: [
                                    if (apodData?.url != null)
                                      Image.network(
                                        apodData!.url!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        apodData?.title ??
                                            'Título no disponible',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (apodData?.type == 'video' &&
                                apodData?.url != null &&
                                apodData!.url!.contains('youtube.com')) {
                              _youtubeController = YoutubePlayerController(
                                initialVideoId: YoutubePlayer.convertUrlToId(
                                    apodData.url!)!,
                                flags: const YoutubePlayerFlags(
                                  autoPlay: false,
                                  mute: false,
                                ),
                              );
                              return Column(
                                children: [
                                  YoutubePlayer(
                                    controller: _youtubeController!,
                                    showVideoProgressIndicator: true,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      apodData.title ?? 'Título no disponible',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            } else if (apodData?.type == 'video') {
                              _videoController =
                                  // ignore: deprecated_member_use
                                  VideoPlayerController.network(apodData!.url!)
                                    ..initialize().then((_) {
                                      setState(() {});
                                      _videoController!.play();
                                    });
                              return Column(
                                children: [
                                  if (_videoController!.value.isInitialized)
                                    AspectRatio(
                                      aspectRatio:
                                          _videoController!.value.aspectRatio,
                                      child: VideoPlayer(_videoController!),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      apodData.title ?? 'Título no disponible',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                  child: Text('Tipo de medio no soportado'));
                            }
                          } else {
                            return const Center(
                                child: Text('No data available'));
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<ApodApi>(
                        future: futureApod,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final apodData = snapshot.data;
                            return FutureBuilder<String>(
                              future: translateDescription(
                                  apodData?.explanation ?? ''),
                              builder: (context, translateSnapshot) {
                                if (translateSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (translateSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${translateSnapshot.error}'));
                                } else if (translateSnapshot.hasData) {
                                  return Text(
                                    translateSnapshot.data ??
                                        'Descripción no disponible',
                                    style: const TextStyle(color: Colors.white),
                                  );
                                } else {
                                  return const Center(
                                      child: Text('No translation available'));
                                }
                              },
                            );
                          } else {
                            return const Center(
                                child: Text('No data available'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
