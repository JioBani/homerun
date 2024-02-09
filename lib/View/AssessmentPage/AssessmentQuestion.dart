class Assessment{
  final String question;
  final List<AssessmentAnswer> answers;

  Assessment({required this.question , required this.answers});

  static List<Assessment> questions = [
    Assessment( //#.0
      question: "현재 혼인 상태가 어떻게 되나요?",
      answers: [
        AssessmentAnswer(answer: "혼인 중이 아님(이혼 포함)" , index: 0),
        AssessmentAnswer(answer: "1년 이내에 혼인할 예정", index: 1),
        AssessmentAnswer(answer: "혼인 한지 7년 이내", index: 2),
        AssessmentAnswer(answer: "혼인 한지 7년 초과", index: 3),
      ]
    ),
    Assessment( //#.1
        question: "자녀가 있나요?",
        answers: [
          AssessmentAnswer(answer: "있음",index: 0),
          AssessmentAnswer(answer: "없음" , index: 1, goto: 4),
        ]
    ),
    Assessment( //#.2
        question: "19세 미만인 자녀가 3명 이상 인가요?",
        answers: [
          AssessmentAnswer(answer: "3명 이상임", index: 0),
          AssessmentAnswer(answer: "아님", index: 1),
        ]
    ),
    Assessment( //#.3
        question: "만 7세 미만인 자녀가 있나요?",
        answers: [
          AssessmentAnswer(answer: "있음", index: 0),
          AssessmentAnswer(answer: "없음", index: 1),
        ]
    ),
    Assessment( //#.4
        question: "테스트",
        answers: [
          AssessmentAnswer(answer: "있음", index: 0),
          AssessmentAnswer(answer: "없음", index: 1),
        ]
    ),
  ];
}

class AssessmentAnswer{
  String answer;
  int? goto;
  int index;

  AssessmentAnswer({required this.answer, required this.index, this.goto});
}