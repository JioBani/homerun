/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Model/SurveyQuestionData.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:logger/logger.dart';

import '../SurveyQuestionWidget.dart';
import 'CheckBoxTableWidget.dart';
import 'CheckBoxWidget.dart';

class SurveyListWidget extends StatefulWidget {
  SurveyListWidget({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<SurveyListWidget> createState() => _SurveyListWidgetState();
}

class _SurveyListWidgetState extends State<SurveyListWidget> {
  AssessmentSurveyPageController controller = Get.find<AssessmentSurveyPageController>();
  double previousOffset = 0;
  final GlobalKey expansionTileKey = GlobalKey();

  List<GlobalKey> keyList = List.generate(5, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(10),
      child: GetX<AssessmentSurveyPageController>(
        builder: (context) {
          return ExpansionPanelList(
            animationDuration: Duration(milliseconds: 500),
            elevation: 4,
            children: [
              SurveyQuestionWidgetTest(
                  surveyIndex: 0,
                  questionData: SurveyQuestionData.period()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 1,
                  questionData: SurveyQuestionData.houseHold()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 2,
                  questionData: SurveyQuestionData.numOfChildren()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 3,
                  questionData: SurveyQuestionData.register()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 0,
                  questionData: SurveyQuestionData.period()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 1,
                  questionData: SurveyQuestionData.houseHold()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 2,
                  questionData: SurveyQuestionData.numOfChildren()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 3,
                  questionData: SurveyQuestionData.register()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 0,
                  questionData: SurveyQuestionData.period()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 1,
                  questionData: SurveyQuestionData.houseHold()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 2,
                  questionData: SurveyQuestionData.numOfChildren()
              ),
              SurveyQuestionWidgetTest(
                  surveyIndex: 3,
                  questionData: SurveyQuestionData.register()
              ),
            ],
            expansionCallback: (int index, bool isExpanded) {
            for(int i = 0; i< controller.isExpanded.length; i++){
              controller.isExpanded[i] = false;
            }
            controller.isExpanded[index] = !isExpanded;

   if (isExpanded) previousOffset = widget.scrollController.offset;
              _scrollToSelectedContent(isExpanded, previousOffset, index, expansionTileKey);

            },
          );
        }
      ),
    );
  }

void _scrollToSelectedContent(bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    StaticLogger.logger.i("스크롤");
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      StaticLogger.logger.i(keyContext);
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      widget.scrollController.animateTo(isExpanded ? (box.size.height * index) : previousOffset,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

}
*/
