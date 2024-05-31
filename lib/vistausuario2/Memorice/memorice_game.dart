import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemoriceGameScreen extends StatefulWidget {
  final int numImages;

  MemoriceGameScreen({required this.numImages});

  @override
  _MemoriceGameScreenState createState() => _MemoriceGameScreenState();
}

class _MemoriceGameScreenState extends State<MemoriceGameScreen> {
  List<Map<String, dynamic>> _imagePairs = [];
  List<Map<String, dynamic>> _shuffledImagePairs = [];
  List<bool> _revealed = [];
  int? _selectedIndex;
  bool _canTap = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('memoryImages').get();

    List<Map<String, dynamic>> allImages = snapshot.docs
        .map((doc) => {'id': doc.id, 'imageUrl': doc['imageUrl']})
        .toList();

    allImages.shuffle();
    List<Map<String, dynamic>> selectedImages =
        allImages.take(widget.numImages).toList();

    _imagePairs = selectedImages + selectedImages;
    _imagePairs.shuffle();

    setState(() {
      _shuffledImagePairs = _imagePairs;
      _revealed = List<bool>.filled(_shuffledImagePairs.length, true);
    });

    // Mostrar las imágenes por 2 segundos al inicio del juego
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _revealed = List<bool>.filled(_shuffledImagePairs.length, false);
      });
    });
  }

  void _onCardTapped(int index) {
    if (_canTap && !_revealed[index]) {
      setState(() {
        _revealed[index] = true;
      });

      if (_selectedIndex == null) {
        _selectedIndex = index;
      } else {
        if (_shuffledImagePairs[_selectedIndex!]['id'] ==
            _shuffledImagePairs[index]['id']) {
          _selectedIndex = null;
        } else {
          _canTap = false;
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _revealed[_selectedIndex!] = false;
              _revealed[index] = false;
              _selectedIndex = null;
              _canTap = true;
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shuffledImagePairs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Memorice'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Memorice'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: _shuffledImagePairs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onCardTapped(index),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[300],
              ),
              child: _revealed[index]
                  ? Image.network(
                      _shuffledImagePairs[index]['imageUrl'],
                      fit: BoxFit.cover,
                    )
                  : Center(child: Icon(Icons.image, size: 50)),
            ),
          );
        },
      ),
    );
  }
}
