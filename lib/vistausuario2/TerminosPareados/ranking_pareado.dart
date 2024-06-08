import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RankingCategoriaScreen extends StatefulWidget {
  final String categoria;

  RankingCategoriaScreen({required this.categoria});

  @override
  _RankingCategoriaScreenState createState() => _RankingCategoriaScreenState();
}

class _RankingCategoriaScreenState extends State<RankingCategoriaScreen> {
  User? _currentUser;
  List<Map<String, dynamic>> _rankings = [];
  int _userPosition = -1;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser == null) {
      print('Usuario no autenticado');
    } else {
      print('Usuario autenticado: ${_currentUser?.uid}');
    }
    _fetchRankings();
  }

  Future<void> _fetchRankings() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('rankings')
          .where('level', isEqualTo: widget.categoria)
          .orderBy('score', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print(
            'No se encontraron rankings para la categoría ${widget.categoria}');
        return;
      }

      Map<String, Map<String, dynamic>> userHighScores = {};

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String userId = data['userId'];
        int score = data['score'];

        if (!userHighScores.containsKey(userId) ||
            userHighScores[userId]!['score'] < score) {
          userHighScores[userId] = {
            'score': score,
            'userId': userId,
          };
        }
      }

      List<Map<String, dynamic>> rankings = [];

      for (var userId in userHighScores.keys) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          String username = userData['username'];
          rankings.add({
            'username': username,
            'score': userHighScores[userId]!['score'],
            'userId': userId,
          });
        }
      }

      rankings.sort((a, b) => b['score'].compareTo(a['score']));

      setState(() {
        _rankings = rankings;

        // Encontrar la posición del usuario actual en el ranking
        _userPosition = rankings.indexWhere(
                (ranking) => ranking['userId'] == _currentUser?.uid) +
            1;
        print('Posición del usuario en ${widget.categoria}: $_userPosition');
      });
    } catch (e) {
      print('Error al obtener los rankings: $e');
      setState(() {
        _errorMessage = 'Error al obtener los rankings: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rankings - ${widget.categoria}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Icon(Icons.leaderboard, size: 28),
          ],
        ),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Añadir espacio alrededor del contenido
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _userPosition > 0
                              ? 'Tu posición: #$_userPosition'
                              : 'Aún no has jugado aquí',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _rankings.length,
                          itemBuilder: (context, index) {
                            var ranking = _rankings[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              elevation: 5,
                              shadowColor: Colors.teal.shade100,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                title: Text(
                                  '${ranking['username']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.teal.shade900,
                                  ),
                                ),
                                subtitle: Text(
                                  'Puntuación: ${ranking['score']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Text(
                                  '#${index + 1}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                tileColor:
                                    ranking['userId'] == _currentUser?.uid
                                        ? Colors.yellowAccent.withOpacity(0.3)
                                        : Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
