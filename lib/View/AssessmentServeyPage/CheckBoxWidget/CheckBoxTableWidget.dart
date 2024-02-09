import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/View/AssessmentPage/AssessmentSurveyPageController.dart';
import 'package:homerun/Model/SurveyQuestionData.dart';
import 'package:homerun/Style/ShadowPalette.dart';

import 'CheckBoxWidget.dart';

class CheckBoxTableWidget extends StatefulWidget {
  const CheckBoxTableWidget({
    super.key ,
    required this.surveyIndex,
    required this.questionData
  });

  final int surveyIndex;
  final SurveyQuestionData questionData;

  @override
  State<CheckBoxTableWidget> createState() => _CheckBoxTableWidgetState();
}

class _CheckBoxTableWidgetState extends State<CheckBoxTableWidget> {

  AssessmentSurveyPageController controller = Get.find<AssessmentSurveyPageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      width: 600.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: [
            ShadowPalette.defaultShadowLight
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
                widget.questionData.title,
                style: TextStyle(
                    fontSize: 35.w,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                )
            ),
          ),
          Builder(
            builder: (context) {
              List<CheckBoxWidget> checkBoxList = [];

              for(int i =0; i< widget.questionData.questions.length; i++){
                checkBoxList.add(CheckBoxWidget(
                  description: widget.questionData.questions[i],
                  index: i,
                  surveyIndex: widget.surveyIndex,
                ));
              }

              return Column(
                children: checkBoxList,
              );
            }
          )
        ],
      ),
    );
  }
}
