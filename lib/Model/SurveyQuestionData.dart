class SurveyQuestionData{
  int numbers;
  String title;
  List<String> questions;

  SurveyQuestionData({
    required this.title ,
    required this.numbers ,
    required this.questions
  });

  static SurveyQuestionData period(){
    return SurveyQuestionData(
      title: "청약 저축 기간은?",
      numbers: 5,
      questions: [
        "입주 저축 가입자",
        "6개월 이하",
        "6개월 이상",
        "12개월 이상",
        "24개월 이상",
      ]
    );
  }

  static SurveyQuestionData houseHold(){
    return SurveyQuestionData(
        title: "세대주 여부",
        numbers: 2,
        questions: [
          "세대주",
          "세대원",
        ]
    );
  }

  static SurveyQuestionData numOfChildren(){
    return SurveyQuestionData(
        title: "자녀수",
        numbers: 5,
        questions: [
          "없음",
          "1명",
          "2명",
          "3명",
          "4명 이상",
        ]
    );
  }

  static SurveyQuestionData register(){
    return SurveyQuestionData(
        title: "자녀 등재 여부",
        numbers: 2,
        questions: [
          "등재",
          "이혼으로 미등재",
        ]
    );
  }
}