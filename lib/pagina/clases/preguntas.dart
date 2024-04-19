class Question {
  late String country;
  String question = "";
  late String answer;
  List<String> options = [];
  String selected = 'Skipped';
  bool correct = false;

  Question.fromJson(Map<String, dynamic> json)
      : country = json['country'],
        answer = json['respuesta'];

  void addOption(List<String> newOptions) {
    question += country;
    options.add(answer);
    options.addAll(newOptions);
    options.shuffle();
  }
}
