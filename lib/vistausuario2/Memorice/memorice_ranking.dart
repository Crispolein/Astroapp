import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemoriceRankingScreen extends StatefulWidget {
  @override
  _MemoriceRankingScreenState createState() => _MemoriceRankingScreenState();
}

class _MemoriceRankingScreenState extends State<MemoriceRankingScreen> {
  User? _currentUser;
  String _currentUsername = '';
  Map<String, List<Ranking>> _rankings = {
    'facil': [],
    'medio': [],
    'dificil': [],
  };
  Map<String, int> _userPositions = {
    'facil': -1,
    'medio': -1,
    'dificil': -1,
  };
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
      _fetchCurrentUsername();
    }
  }

  Future<void> _fetchCurrentUsername() async {
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_currentUser!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _currentUsername = userDoc['username'] ?? 'Desconocido';
        });
        _fetchRankings();
      } else {
        setState(() {
          _errorMessage = 'No se pudo obtener el nombre de usuario actual.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchRankings() async {
    try {
      for (String level in ['facil', 'medio', 'dificil']) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('rankings')
            .where('game', isEqualTo: 'memorice')
            .where('level', isEqualTo: level)
            .orderBy('score', descending: true)
            .get();

        if (querySnapshot.docs.isEmpty) {
          print('No se encontraron rankings para el nivel $level');
          continue;
        }

        Map<String, Ranking> uniqueRankings = {};
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Ranking ranking = Ranking.fromMap(data);
          if (!uniqueRankings.containsKey(ranking.userId) ||
              uniqueRankings[ranking.userId]!.score < ranking.score) {
            uniqueRankings[ranking.userId] = ranking;
          }
        }

        List<Ranking> rankings = uniqueRankings.values.toList();
        rankings.sort((a, b) =>
            b.score.compareTo(a.score)); // Ordenar por puntaje descendente

        setState(() {
          _rankings[level] = rankings;
          _userPositions[level] = rankings.indexWhere(
                  (ranking) => ranking.username == _currentUsername) +
              1;
          print('Posición del usuario en $level: ${_userPositions[level]}');
        });
      }
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rankings de Memorice'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Fácil'),
              Tab(text: 'Medio'),
              Tab(text: 'Difícil'),
            ],
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontSize: 18),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : TabBarView(
                    children: [
                      _buildRankingList('facil'),
                      _buildRankingList('medio'),
                      _buildRankingList('dificil'),
                    ],
                  ),
      ),
    );
  }

  Widget _buildRankingList(String level) {
    List<Ranking> rankings = _rankings[level]!;
    int userPosition = _userPositions[level]!;
    String userPositionText = userPosition > 0
        ? 'Tu posición: #$userPosition'
        : 'Aún no has jugado aquí';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            userPositionText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rankings.length,
            itemBuilder: (context, index) {
              Ranking ranking = rankings[index];
              String userName = ranking.username ?? 'Desconocido';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Puntuación: ${ranking.score}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Text(
                    '#${index + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tileColor: ranking.username == _currentUsername
                      ? Colors.yellow
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Ranking {
  final String userId;
  final String username;
  final int score;

  Ranking({required this.userId, required this.username, required this.score});

  factory Ranking.fromMap(Map<String, dynamic> data) {
    return Ranking(
      userId: data['userId'] ?? '',
      username: data['username'] ?? 'Desconocido',
      score: data['score'] ?? 0,
    );
  }
}
