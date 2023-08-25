import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Model/SurveyQuestionData.dart';
import 'package:homerun/Style/ShadowPalette.dart';

import 'SurveyListWidget/CheckBoxTableWidget.dart';
import 'SurveyListWidget/CheckBoxWidget.dart';

class SurveyQuestionWidget extends ExpansionPanel{
  AssessmentSurveyPageController controller;
  final SurveyQuestionData questionData;
  final int surveyIndex;

  SurveyQuestionWidget({required this.controller , required this.questionData, required this.surveyIndex }) : super(
      headerBuilder: (context , isExpanded){
        return ListTile(
          title: Text(questionData.title,
            style: TextStyle(
                fontSize: 35.w,
                fontWeight: FontWeight.w700
            ),
          ),
          subtitle: GetX<AssessmentSurveyPageController>(
            builder: (context) {
              return Text(controller.getContent(surveyIndex, questionData));
            }
          ),
        );
      },
      body: IntrinsicHeight(
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                                questionData.title,
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

                                for(int i =0; i< questionData.questions.length; i++){
                                  checkBoxList.add(CheckBoxWidget(
                                    description: questionData.questions[i],
                                    index: i,
                                    surveyIndex: surveyIndex,
                                  ));
                                }

                                return Column(
                                  children: checkBoxList,
                                );
                              }
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 195.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.w),
                          boxShadow: [ShadowPalette.defaultShadowLight]
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: (){
                      controller.closeAllExpand();
                    },
                    child: Text("확인")
                )
              ],
            );
          }
        ),
      ),
      isExpanded: controller.isExpanded[surveyIndex],
      canTapOnHeader: true
  );

}
