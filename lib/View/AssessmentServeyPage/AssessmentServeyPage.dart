import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Palette.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/AssessmentServeyPage/ProgressBoxWidget.dart';
import 'package:logger/logger.dart';


import 'CategoryButtonTableWidget/CategoryButtonTableWidget.dart';
import 'SurveyListWidget/SurveyListWidget.dart';

class AssessmentSurveyPage extends StatefulWidget {
  const AssessmentSurveyPage({super.key});

  @override
  State<AssessmentSurveyPage> createState() => _AssessmentSurveyPageState();
}

class _AssessmentSurveyPageState extends State<AssessmentSurveyPage> {

  AssessmentSurveyPageController controller = Get.put(AssessmentSurveyPageController());
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('국민주택',
            style: TextStyle(
            fontSize: 40.w,
            fontWeight: FontWeight.w600
          ),
        ), // 화면 제목
        centerTitle: true, // 제목을 가운데로 정렬
        actions: <Widget>[
          // 오른쪽 끝에 아이콘 버튼 추가
          IconButton(
            icon: Icon(Icons.import_export),
            onPressed: () {
              controller.loadData();
            },
            iconSize: 60.w,
          ),
        ],
      ),
      body: SafeArea(
          child: ListView(
            children: [
              Container(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("특별공급",
                        style: TextStyle(
                            fontSize: 30.w,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      CategoryButtonTableWidget(),
                      SizedBox(height: 20.w,),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProgressBoxWidget(content: "기본질문서"),
                  ProgressBoxWidget(content: "추가질문서",),
                  ProgressBoxWidget(content: "자격진단결과",),
                ],
              ),
              SurveyListWidget()
            ],
          )
      ),
    );
  }
}
