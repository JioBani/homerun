import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';

class SurveyData{
  final List<SurveyQuestionData> questions;

  SurveyData({required this.questions});

  static SurveyData? fromMap(List<dynamic> documentMap){
    try{
      List<SurveyQuestionData> questions = [];

      for (var survey in documentMap) {
         var question = SurveyQuestionData.fromMap(Map<String , dynamic>.from(survey));
         if(question != null) questions.add(question);
      }

      return SurveyData(questions: questions);
    }
    catch(e){
      StaticLogger.logger.e(e);
      return null;
    }
  }

  /*factory SurveyData.fromTest() {
    return SurveyData(questions: [
      SurveyQuestionData(
        question: '당신의 성별은 무엇입니까?',
        answers: ['남자', '여자'],
        result: [10,10]
      ),
      SurveyQuestionData(
        question: '당신의 나이는 몇 살입니까?',
        answers: ['18-24', '25-34'],
        result: [10,10]
      ),
      SurveyQuestionData(
        question: '당신의 좋아하는 색깔은 무엇인가요?',
        answers: ['빨강', '파랑', '노랑', '초록'],
        result: [10,10,10,10]
      ),
      SurveyQuestionData(
        question: '당신의 현재 직업은 무엇인가요?',
        answers: ['학생', '직장인', '자영업자', '주부'],
        result: [10,10,10,10]
      ),
      SurveyQuestionData(
        question: '당신의 가장 좋아하는 음식은 무엇인가요?',
        answers: ['피자', '스테이크', '햄버거', '스시'],
        result: [10,10,10,10]
      ),
    ]);
  }*/


}

class SurveyQuestionData{
  final String question;
  final List<SurveyAnswerData> answers;
  /*final List<String> answers;
  final List<int> result;*/
  int index = -1;

  SurveyQuestionData({required this.question , required this.answers});

  static SurveyQuestionData? fromDocumentSnapshot(DocumentSnapshot documents){

    try{
      List<Map<String , dynamic>> answers = List<Map<String , dynamic>>.from(documents['answers']);
      return SurveyQuestionData(
        question: documents['question'],
        answers: answers.map((answer) =>
            SurveyAnswerData(
                answer: answer['answer'],
                votes: answer['result']
            )
        ).toList(),
      );
    }catch(e){
      StaticLogger.logger.e(e);
      return null;
    }
  }

  static SurveyQuestionData? fromMap(Map<String , dynamic> map){
    try{
      List<Map<String , dynamic>> answers = List<Map<String , dynamic>>.from(map['answers']);
      return SurveyQuestionData(
        question: map['question'],
        answers: answers.map((answer) =>
            SurveyAnswerData(
                answer: answer['answer'],
                votes: answer['result']
            )
        ).toList(),
      );
    }catch(e){
      StaticLogger.logger.e(e);
      return null;
    }
  }

}

class SurveyAnswerData{
  String answer;
  int votes;

  SurveyAnswerData({required this.answer , required this.votes});
}