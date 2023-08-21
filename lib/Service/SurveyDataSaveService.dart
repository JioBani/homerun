import 'package:shared_preferences/shared_preferences.dart';

class SurveyDataSaveService{

  static SurveyDataSaveService? _instance;

  SurveyDataSaveService._();

  static SurveyDataSaveService get instance {
    // 이미 인스턴스가 생성된 경우, 해당 인스턴스를 반환합니다.
    _instance ??= SurveyDataSaveService._();
    return _instance!;
  }

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> loadData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }
}
