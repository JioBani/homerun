import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/PresaleInfomationPage/SurveyResultController.dart';
import 'package:homerun/Model/SurveyData.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SurveyResultWidget extends StatefulWidget {
  const SurveyResultWidget({super.key, required this.surveyQuestionData});
  final SurveyQuestionData surveyQuestionData;

  @override
  State<SurveyResultWidget> createState() => _SurveyResultWidgetState();
}

class _SurveyResultWidgetState extends State<SurveyResultWidget> {
  @override
  Widget build(BuildContext context) {

    SurveyResultController controller = SurveyResultController(
        surveyQuestionData: widget.surveyQuestionData
    );


    List<Widget> widgets = [];

    controller.getPercent().forEach((answerData, percent) {
      widgets.add(
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 48.h,
              animationDuration: 1000,
              percent: answerData.votes / controller.allVotes,
              center: Text(
                "${answerData.answer}($percent%)",
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              barRadius: Radius.circular(16.r),
              progressColor: Colors.green,
            ),
          )
      );
    });

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: widgets
      ),
    );
  }
}
