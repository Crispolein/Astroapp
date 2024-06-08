import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerdaderoFalsoRankingScreen extends StatefulWidget {
  @override
  _VerdaderoFalsoRankingScreenState createState() =>
      _VerdaderoFalsoRankingScreenState();
}

class _VerdaderoFalsoRankingScreenState
    extends State<VerdaderoFalsoRankingScreen> {
  User? _currentUser;
  Map<String, List<Ranking>> _rankings = {
    'Facil': [],
    'Medio': [],
    'Difícil': [],
  };
  Map<String, int> _userPositions = {
    'Facil': -1,
    'Medio': -1,
    'Difícil': -1,
  };
  Map<String, String> _userNames = {}; // Almacenar nombres de usuarios
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _fetchRankings();
  }

  Future<void> _fetchRankings() async {
    try {
      for (String level in ['Facil', 'Medio', 'Difícil']) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('rankings')
            .where('game', isEqualTo: 'TrueFalse')
            .where('level', isEqualTo: level)
            .orderBy('score', descending: true)
            .get();

        Map<String, Ranking> uniqueRankings = {};
        for (var doc in querySnapshot.docs) {
          Ranking ranking = Ranking.fromMap(doc.data() as Map<String, dynamic>);
          if (!uniqueRankings.containsKey(ranking.userId) ||
              uniqueRankings[ranking.userId]!.score < ranking.score) {
            uniqueRankings[ranking.userId] = ranking;
          }
        }

        List<Ranking> rankings = uniqueRankings.values.toList();
        rankings.sort((a, b) => b.score.compareTo(a.score));

        for (Ranking ranking in rankings) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(ranking.userId)
              .get();

          if (userDoc.exists) {
            _userNames[ranking.userId] = userDoc['username'];
          } else {
            _userNames[ranking.userId] = 'Desconocido';
          }
        }

        setState(() {
          _rankings[level] = rankings;
          _userPositions[level] = rankings.indexWhere(
                  (ranking) => ranking.userId == _currentUser?.uid) +
              1;
        });
      }
    } catch (e) {
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
          title: Text('Rankings de Verdadero o Falso'),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(child: Text('Facil', style: TextStyle(fontSize: 18))),
              Tab(child: Text('Medio', style: TextStyle(fontSize: 18))),
              Tab(child: Text('Difícil', style: TextStyle(fontSize: 18))),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : TabBarView(
                    children: [
                      _buildRankingList('Facil'),
                      _buildRankingList('Medio'),
                      _buildRankingList('Difícil'),
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
              String userName = _userNames[ranking.userId] ?? 'Desconocido';

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
                  tileColor: ranking.userId == _currentUser?.uid
                      ? Colors.yellowAccent.withOpacity(0.5)
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
