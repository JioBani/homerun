import 'package:get/get.dart';
import 'package:homerun/Model/SurveyData.dart';

class SurveyResultController{
  final SurveyQuestionData surveyQuestionData;
  int allVotes = 0;

  SurveyResultController({required this.surveyQuestionData}){
    for (var answer in surveyQuestionData.answers) {
      allVotes += answer.votes;
    }
  }

  Map<SurveyAnswerData , int> getPercent() {
    Map<SurveyAnswerData, int> map = <SurveyAnswerData, int>{};
    for (var element in surveyQuestionData.answers) {
      map[element] = ((element.votes / allVotes * 100).ceil());
    }
    return map;
  }
}