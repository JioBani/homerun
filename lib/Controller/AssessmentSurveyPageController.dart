import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:homerun/Model/SurveyData.dart';
import 'package:homerun/Service/SurveyDataSaveService.dart';

class AssessmentSurveyPageController extends GetxController{

  RxInt selectedValue = RxInt(-1);

  SurveyData surveyData = SurveyData(-1);
  List<bool> values = List.generate(5, (index) => false);
  List<bool> isExpanded = List.generate(5, (index) => false).obs;


  Future<void> loadData() async {
    var loadData = await SurveyDataSaveService.instance.loadSurveyData();
    if(loadData != null){
      surveyData = loadData;
      for(int i = 0; i< values.length; i++){
        values[i] = surveyData!.period == i;
      }
      selectedValue.value = surveyData!.period;
    }
    return;
  }

  Future<void> changeData(int index) async {
    for(int i = 0; i< values.length; i++){
      if(index == i){
        values[i] = !values[i];
      }
      else{
        values[i] = false;
      }
    }
    surveyData!.period = index;

    await SurveyDataSaveService.instance.saveSurveyData(surveyData);
    return;
  }

  void select(int value) {
    selectedValue.value = value;
    changeData(value);
  }


}