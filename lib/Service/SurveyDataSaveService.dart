
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/SharedPreferencesService.dart';

import '../Model/Question.dart';

class SurveyDataSaveService{

  static SurveyDataSaveService? _instance;

  SurveyDataSaveService._();

  static SurveyDataSaveService get instance {
    // 이미 인스턴스가 생성된 경우, 해당 인스턴스를 반환합니다.
    _instance ??= SurveyDataSaveService._();
    return _instance!;
  }


  Future<QuestionData?> loadSurveyData()async{
    String? jsonString = await SharedPreferencesService.instance.loadData("survey_data");
    if(jsonString != null){
      return QuestionData.stringToData(jsonString);
    }
    else{
      StaticLogger.logger.e("survey_data 가 null 임");
      return null;
    }
  }

  Future<void> saveSurveyData(QuestionData surveyData)async{
    String jsonString = surveyData.toJsonString();
    await SharedPreferencesService.instance.saveData("survey_data", jsonString);
    return;
  }

}
