import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Model/SurveyQuestionData.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:logger/logger.dart';

import '../SurveyQuestionWidget.dart';
import 'CheckBoxTableWidget.dart';
import 'CheckBoxWidget.dart';

class SurveyListWidget extends StatefulWidget {
  SurveyListWidget({super.key});

  @override
  State<SurveyListWidget> createState() => _SurveyListWidgetState();
}

class _SurveyListWidgetState extends State<SurveyListWidget> {
  AssessmentSurveyPageController controller = Get.find<AssessmentSurveyPageController>();

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
              SurveyQuestionWidget(
                  controller: controller ,
                  surveyIndex: 0,
                  questionData: SurveyQuestionData.period()
              ),
              SurveyQuestionWidget(
                  controller: controller ,
                  surveyIndex: 1,
                  questionData: SurveyQuestionData.houseHold()
              ),
              SurveyQuestionWidget(
                  controller: controller ,
                  surveyIndex: 2,
                  questionData: SurveyQuestionData.numOfChildren()
              ),
              SurveyQuestionWidget(
                  controller: controller ,
                  surveyIndex: 3,
                  questionData: SurveyQuestionData.register()
              ),
            ],
            expansionCallback: (int index, bool isExpanded) {
              for(int i = 0; i< controller.isExpanded.length; i++){
                controller.isExpanded[i] = false;
              }
              controller.isExpanded[index] = !isExpanded;
            },
          );
        }
      ),
    );
  }
}
