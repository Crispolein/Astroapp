import 'package:astro_app/pagina/clases/preguntas.dart';
import 'package:astro_app/pagina/clases/quiz.dart';
import 'package:astro_app/pagina/results_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int totalQuestions = 4;
  int totalOptions = 4;
  int questionIndex = 0;
  int progressIndex = 0;
  Quiz quiz = Quiz(name: 'Quiz de planetas', questions: []);

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/images/preguntas.json');
    final List<dynamic> data = await json.decode(response);
    List<int> optionList = List<int>.generate((data.length), (i) => i);
    List<int> questionsAdded = [];

    while (true) {
      optionList.shuffle();
      int answer = optionList[0];
      if (questionsAdded.contains(answer)) continue;
      questionsAdded.add(answer);

      List<String> otherOptions = [];
      for (var option in optionList.sublist(1, totalOptions)) {
        otherOptions.add(data[option]['respuesta']);
      }
      Question question = Question.fromJson(data[answer]);
      question.addOption(otherOptions);
      quiz.questions.add(question);

      if (quiz.questions.length >= totalQuestions) break;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  void _optionSelcted(String selected) {
    quiz.questions[questionIndex].selected = selected;
    if (selected == quiz.questions[questionIndex].answer) {
      quiz.questions[questionIndex].correct = true;
      quiz.right += 1;
    }
    progressIndex += 1;
    if (questionIndex < totalQuestions - 1) {
      questionIndex += 1;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => _buildResultDialog(context));
    }

    setState(() {});
  }

  Widget _buildResultDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Resultados', style: Theme.of(context).textTheme.headline1),
      backgroundColor: Theme.of(context).primaryColorDark,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preguntas totales: $totalQuestions',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text('Correctas: ${quiz.right}',
              style: Theme.of(context).textTheme.bodyText1),
          Text('Incorrectas: ${(totalQuestions - quiz.right)}',
              style: Theme.of(context).textTheme.bodyText1),
          Text('Porcentaje aprobado: ${quiz.percent}%',
              style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ResultsPage(
                        quiz: quiz,
                      ))),
            );
          },
          child: Text(
            'Ver Respuestas',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extender el fondo detrás de la AppBar
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Hacer transparente el fondo de la AppBar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(quiz.name),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/imagen1.jpg"), // Reemplaza con la ruta de tu imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: LinearProgressIndicator(
                    color: Color.fromARGB(255, 50, 232, 245),
                    value: progressIndex / totalQuestions,
                    minHeight: 20,
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: quiz.questions.isNotEmpty
                      ? Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(15),
                                child: Text(
                                  quiz.questions[questionIndex].question,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ),
                              // Aquí puedes agregar tu texto entre la pregunta y las respuestas
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: totalOptions,
                                  itemBuilder: (_, index) {
                                    return Container(
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 144, 159, 255),
                                            width: 3),
                                      ),
                                      child: ListTile(
                                        leading: Text('${index + 1}'),
                                        title: Text(quiz
                                            .questions[questionIndex]
                                            .options[index]),
                                        onTap: () {
                                          _optionSelcted(quiz
                                              .questions[questionIndex]
                                              .options[index]);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : const CircularProgressIndicator(
                          backgroundColor: Colors.black,
                        ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _optionSelcted('Skipped');
                },
                child:
                    Text('skip', style: Theme.of(context).textTheme.bodyText1),
              )
            ],
          ),
        ],
      ),
    );
  }
}
