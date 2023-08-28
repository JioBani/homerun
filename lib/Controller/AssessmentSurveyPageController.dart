import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/SurveyData.dart';
import 'package:homerun/Model/SurveyQuestionData.dart';
import 'package:homerun/Service/SurveyDataSaveService.dart';

import '../View/AssessmentServeyPage/SurveyQuestionWidget.dart';

class AssessmentSurveyPageController extends GetxController{

  RxInt selectedValue = RxInt(-1);

  Rx<SurveyData> surveyData = SurveyData(-1 , -1 , -1, -1).obs;
  List<bool> values = List.generate(5, (index) => false);
  List<bool> isExpanded = List.generate(5, (index) => false).obs;
  List<String> subTitle = List.generate(5, (index) => "선택없음").obs;
  var selectTile = -1.obs;

  late final ScrollController scrollController;
  late final ListView listView;
  late final GlobalKey listViewKey;

  void setScrollController(ScrollController scrollController){
    this.scrollController = scrollController;
  }

  void setListView(ListView listView){
    this.listView = listView;
  }

  void setListViewKey(GlobalKey listViewKey){
    this.listViewKey = listViewKey;
  }

  double getWidgetHeight(GlobalKey key, BuildContext context) {
    // GlobalKey를 사용하여 위젯을 찾습니다.
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;


    // 위젯의 높이를 가져옵니다.
    final widgetHeight = renderBox.size.height;

    return widgetHeight;
  }

  double getWidgetPositionY(GlobalKey key, BuildContext context) {
    // GlobalKey를 사용하여 위젯을 찾습니다.
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;

    // 위젯의 위치를 가져옵니다.
    final position = renderBox.localToGlobal(Offset.zero, ancestor: listViewKey.currentContext!.findRenderObject());

    return position.dy;
  }


  Future<void> loadData() async {
    var loadData = await SurveyDataSaveService.instance.loadSurveyData();
    if(loadData != null){
      surveyData.value = loadData;
      for(int i = 0; i< values.length; i++){
        values[i] = surveyData!.value.period == i;
      }
      selectedValue.value = surveyData!.value.period;
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

    await SurveyDataSaveService.instance.saveSurveyData(surveyData.value);
    return;
  }

  void select(int surveyIndex , int value) {
    if(value == selectedValue.value){
      selectedValue.value = -1;
    }
    else{
      selectedValue.value = value;
    }

    switch(surveyIndex){
      case 0 : updatePeriod(selectedValue.value);
      case 1 : updateHouseHold(selectedValue.value);
      case 2 : updateNumOfChild(selectedValue.value);
      case 3 : updateChildrenRegistered(selectedValue.value);
    }

    changeData(selectedValue.value);
  }

  void updatePeriod(int value){
    StaticLogger.logger.i("updatePeriod $value");
    surveyData.update((val) {
      val?.period = value;
    });
  }

  void updateHouseHold(int value){
    StaticLogger.logger.i("updateHouseHold $value");
    surveyData.update((val) {
      val?.isHouseholdMember = value;
    });
  }

  void updateNumOfChild(int value){
    StaticLogger.logger.i("updateNumOfChild $value");
    surveyData.update((val) {
      val?.numOfChild = value;
    });
  }

  void updateChildrenRegistered(int value){
    StaticLogger.logger.i("updateChildrenRegistered $value");
    surveyData.update((val) {
      val?.isChildrenRegistered = value;
    });
  }

  bool getBool(int surveyIndex , int checkIndex){
    switch(surveyIndex){
      case 0 : return surveyData.value.period == checkIndex;
      case 1 : return surveyData.value.isHouseholdMember == checkIndex;
      case 2 : return surveyData.value.numOfChild == checkIndex;
      case 3 : return surveyData.value.isChildrenRegistered == checkIndex;
    }
    return false;
  }

  int getCheck(int surveyIndex){
    switch(surveyIndex){
      case 0 : return surveyData.value.period;
      case 1 : return surveyData.value.isHouseholdMember;
      case 2 : return surveyData.value.numOfChild;
      case 3 : return surveyData.value.isChildrenRegistered;
    }
    return -1;
  }

  String getContent(int surveyIndex , SurveyQuestionData questionData){
    final selectNum = getCheck(surveyIndex);
    if(selectNum == -1) return "선택안함";
    else{
      try{
        return questionData.questions[selectNum];
      }catch(e){
        StaticLogger.logger.e(e);
        return "선택안함";
      }
    }
  }

  void closeAllExpand(){
    for(int i =0; i<isExpanded.length; i++ ){
      isExpanded[i] = false;
    }
  }

  List<SurveyQuestionData> getQuestionData(){
    return [
      SurveyQuestionData.period(),
      SurveyQuestionData.houseHold(),
      SurveyQuestionData.numOfChildren(),
      SurveyQuestionData.register(),
    ];
  }

}