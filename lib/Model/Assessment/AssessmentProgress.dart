import 'dart:convert';

class AssessmentProgress{
  List<int?> answers;
  int nextQuestion;

  AssessmentProgress({
    required this.answers,
    required this.nextQuestion,
  });

  String toJson(){
    List<int> list = answers.map((e) => e ?? -1).toList();
    Map<String , dynamic> map = Map();
    map['answers'] = list;
    map['nextQuestion'] = nextQuestion;
    return jsonEncode(map);
  }

  factory AssessmentProgress.fromJson(String jsonString) {
    Map<String, dynamic> map = json.decode(jsonString);
    List<int?> decodedAnswers = (map['answers'] as List<dynamic>)
        .map((e) => e == -1 ? null : e as int)
        .toList();
    int decodedNextQuestion = map['nextQuestion'] as int;
    return AssessmentProgress(
      answers: decodedAnswers,
      nextQuestion: decodedNextQuestion,
    );
  }

}