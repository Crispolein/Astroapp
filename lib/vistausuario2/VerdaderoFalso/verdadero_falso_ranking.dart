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
    if (_currentUser == null) {
      // Manejar el caso donde el usuario no está autenticado
      print('Usuario no autenticado');
    } else {
      print('Usuario autenticado: ${_currentUser?.uid}');
    }
    _fetchRankings();
  }

  Future<void> _fetchRankings() async {
    try {
      for (String level in ['Facil', 'Medio', 'Difícil']) {
        print('Fetching rankings for level: $level');
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('rankings')
            .where('game', isEqualTo: 'TrueFalse')
            .where('level', isEqualTo: level)
            .orderBy('score', descending: true)
            .get();

        if (querySnapshot.docs.isEmpty) {
          print('No se encontraron rankings para el nivel $level');
          continue;
        }

        Map<String, Ranking> uniqueRankings = {};
        for (var doc in querySnapshot.docs) {
          Ranking ranking = Ranking.fromMap(doc.data() as Map<String, dynamic>);
          // Solo conservar el puntaje más alto de cada usuario
          if (!uniqueRankings.containsKey(ranking.userId) ||
              uniqueRankings[ranking.userId]!.score < ranking.score) {
            uniqueRankings[ranking.userId] = ranking;
          }
        }

        List<Ranking> rankings = uniqueRankings.values.toList();
        rankings.sort((a, b) => b.score
            .compareTo(a.score)); // Ordenar nuevamente después de filtrar

        // Obtener nombres de usuario
        for (Ranking ranking in rankings) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(ranking.userId)
              .get();

          if (userDoc.exists) {
            _userNames[ranking.userId] = userDoc['username'];
            print('Usuario obtenido: ${userDoc.id} - ${userDoc['username']}');
          } else {
            _userNames[ranking.userId] = 'Desconocido';
            print('Usuario no encontrado: ${ranking.userId}');
          }
        }

        setState(() {
          _rankings[level] = rankings;

          // Encontrar la posición del usuario actual en el ranking
          _userPositions[level] = rankings.indexWhere(
                  (ranking) => ranking.userId == _currentUser?.uid) +
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
          title: Text('Rankings de Verdadero o Falso'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Facil'),
              Tab(text: 'Medio'),
              Tab(text: 'Difícil'),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rankings.length,
            itemBuilder: (context, index) {
              Ranking ranking = rankings[index];
              String userName = _userNames[ranking.userId] ?? 'Desconocido';

              return ListTile(
                title: Text(userName),
                subtitle: Text('Puntuación: ${ranking.score}'),
                trailing: Text('#${index + 1}'),
                tileColor: ranking.userId == _currentUser?.uid
                    ? Colors.yellowAccent
                    : null,
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
      username: data['username'] ??
          'Desconocido', // Asegurar que el username no sea null
      score: data['score'] ?? 0,
    );
  }
}
