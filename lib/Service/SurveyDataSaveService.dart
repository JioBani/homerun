import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyDataSaveService{

  static SurveyDataSaveService? _instance;
  Logger _logger = Logger();

  SurveyDataSaveService._();

  static SurveyDataSaveService get instance {
    // 이미 인스턴스가 생성된 경우, 해당 인스턴스를 반환합니다.
    _instance ??= SurveyDataSaveService._();
    return _instance!;
  }

  Future<void> saveData(String key, String value) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      _logger.log(Level.info, "데이터 저장 성공 : {${key} : ${value}}");
    }
    catch(e){
      _logger.e(e);
    }
  }

  Future<String> loadData(String key) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? result = prefs.getString(key);
      if(result == null){
        _logger.log(Level.warning, "키가 없음 : ${key}");
        return "";
      }
      else{
        _logger.log(Level.info, "데이터 불러오기 성공 : {${key} : ${result}}");
        return result;
      }
    }
    catch(e){
      _logger.e(e);
      return "";
    }


  }
}
