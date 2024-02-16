import 'dart:convert';

import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/AssessmentProgress.dart';
import 'package:homerun/Service/FileDataService.dart';

class AssessmentDataService{
  static Future<bool> saveAnswer(AssessmentProgress assessmentProgress) async {
    Object? exception;
    StackTrace? stacktrace;
    (exception , stacktrace) = await FileDataService.saveAsString("assessment_answers.json" , assessmentProgress.toJson());

    if(exception != null){
      StaticLogger.logger.e("[AssessmentDataService.saveAnswer()] 결과 저장 실패 : $exception");
      return false;
    }
    else{
      return true;
    }
  }

  static Future<AssessmentProgress?> loadAnswer() async {
    Object? exception;
    StackTrace? stacktrace;
    String? result;

    (result , exception , stacktrace) = await FileDataService.readAsString("assessment_answers.json");

    if(exception != null){
      StaticLogger.logger.e("[AssessmentDataService.loadAnswer()] 결과 불러오기 실패 : $exception");
      return null;
    }
    else{
      try{
        return AssessmentProgress.fromJson(result!);
      }catch(e , s){
        StaticLogger.logger.e("[AssessmentDataService.loadAnswer()] 결과 변환 실패 : $e\n$s");
        return null;
      }
    }
  }

  static Future<bool> removeAnswer() async {
    Object? exception;
    StackTrace? stacktrace;
    (exception , stacktrace) = await FileDataService.removeFile("assessment_answers.json");

    if(exception != null){
      StaticLogger.logger.e("[AssessmentDataService.removeAnswer()] 삭제 실패 : $exception");
      return false;
    }
    else{
      return true;
    }
  }
}