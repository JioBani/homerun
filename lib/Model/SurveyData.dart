import 'dart:convert';

import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:logger/logger.dart';

class SurveyData{

  //#. 변수
  int period;
  int isHouseholdMember;
  int numOfChild;
  int isChildrenRegistered;

  //#. 생성자
  SurveyData(
      this.period,
      this.isHouseholdMember,
      this.numOfChild,
      this.isChildrenRegistered
      );


  //#. 함수
  String toJsonString(){
    Map<String, dynamic> jsonObject = {
      "period": period,
      "isHouseholdMember": isHouseholdMember,
      "numOfChild": numOfChild,
      "isChildrenRegistered": isChildrenRegistered,
    };

    return json.encode(jsonObject);
  }

  static SurveyData? stringToData(String jsonString){
    try {
      Map<String, dynamic> loadedJson = json.decode(jsonString);
      return SurveyData(
          loadedJson['period'] ,
          loadedJson['isHouseholdMember'],
          loadedJson['numOfChild'],
          loadedJson['isChildrenRegistered']
      );
    } catch (e) {
      // JSON 형식이 아닌 데이터를 처리하는 예외처리
      StaticLogger.logger.e(e);
    }
  }
}