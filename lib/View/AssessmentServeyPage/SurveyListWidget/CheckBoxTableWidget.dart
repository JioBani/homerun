import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Service/SurveyDataSaveService.dart';
import 'package:homerun/Style/ShadowPalette.dart';

import 'CheckBoxWidget.dart';

class CheckBoxTableWidget extends StatefulWidget {
  const CheckBoxTableWidget({super.key});

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
                "청약 저축 기간은?",
                style: TextStyle(
                    fontSize: 35.w,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                )
            ),
          ),
          CheckBoxWidget(
            description: "1) 입주 저축 가입자",
            index: 0,
          ),
          CheckBoxWidget(
            description: "2) 6개월 이하",
            index: 1,
          ),
          CheckBoxWidget(
              description: "3) 6개월 이상",
            index: 2,
          ),
          CheckBoxWidget(
              description: "4) 12개월 이상",
            index: 3,
          ),
          CheckBoxWidget(
              description: "5) 24개월 이상",
            index: 4,
          ),
        ],
      ),
    );
  }
}
