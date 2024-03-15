import 'dart:convert';

class AssessmentDto{
  List<Assessment> assessmentList;
  String version;

  AssessmentDto({required this.assessmentList , required this.version});

  Map<String, dynamic> toMap() {
    return {
      'assessmentList': assessmentList.map((assessment) => assessment.toMap()).toList(),
      'version': version,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  /*static AssessmentDto fromJson(Map<String, dynamic> json) {
    return AssessmentDto(
      assessmentList: (json['assessmentList'] as List)
          .map((assessmentJson) => Assessment.fromJson(assessmentJson))
          .toList(),
      version: json['version'],
    );
  }*/

  factory AssessmentDto.fromMap(Map<String, dynamic> map) {
    return AssessmentDto(
      assessmentList: (map['assessmentList'] as List)
          .map((assessmentData) => Assessment.fromMap(assessmentData))
          .toList(),
      version: map['version'],
    );
  }
}

class Assessment{
  final String question;
  final String id;
  final List<AssessmentAnswer> answers;

  Assessment({required this.id , required this.question , required this.answers});

  String toJson() {
    return jsonEncode({
      'question': question,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    });
  }

  /*static Assessment fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Assessment(
      id: json['id'],
      question: json['question'],
      answers: (json['answers'] as List)
          .map((answerJson) => AssessmentAnswer.fromJson(answerJson))
          .toList(),
    );
  }*/

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'question': question,
      'answers': answers.map((answer) => answer.toMap()).toList(),
    };
  }

  factory Assessment.fromMap(Map<String, dynamic> map) {
    return Assessment(
      id : map['id'],
      question: map['question'],
      answers: (map['answers'] as List)
          .map((answerData) => AssessmentAnswer.fromMap(answerData))
          .toList(),
    );
  }
}

class AssessmentAnswer{
  String answer;
  int? goto;
  int index;

  AssessmentAnswer({required this.answer, required this.index, this.goto});

  String toJson() {
    return jsonEncode({
      'answer': answer,
      'goto': goto,
      'index': index,
    });
  }

  /*static AssessmentAnswer fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return AssessmentAnswer(
      answer: json['answer'],
      goto: json['goto'],
      index: json['index'],
    );
  }*/

  factory AssessmentAnswer.fromMap(Map<String, dynamic> map) {
    return AssessmentAnswer(
      answer: map['answer'],
      goto: map['goto'],
      index: map['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'goto': goto,
      'index': index,
    };
  }
}