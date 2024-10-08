import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Model/SurveyData.dart';
import 'package:homerun/View/SaleInfomation/PresaleInfo/SurveyResultWidget.dart';

class SurveyListWidget extends StatelessWidget {
  const SurveyListWidget({super.key, required this.surveyData});

  final SurveyData? surveyData;

  @override
  Widget build(BuildContext context) {

    final List<Widget> surveyWidgetList = [];

    if(surveyData != null){
      for (var element in surveyData!.questions) {
        surveyWidgetList.add(SurveyWidget(surveyQuestionData: element,));
      }
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: surveyWidgetList,
    );
  }
}


class SurveyWidget extends StatefulWidget {
  const SurveyWidget({super.key, required this.surveyQuestionData});
  final SurveyQuestionData surveyQuestionData;

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  String? selectedRadioValue;
  bool isShowResult = false;

  void onTap(String? value){
    selectedRadioValue = value;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Text(
              widget.surveyQuestionData.question,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: 100.h,
            ),
            child: Builder(
              builder: (context){
                if(isShowResult){
                  //return SizedBox();
                  return SurveyResultWidget(surveyQuestionData: widget.surveyQuestionData);
                }
                else{
                  List<SurveyRadioButtonWidget> buttons = [];

                  for (var answer in widget.surveyQuestionData.answers) {
                    buttons.add(
                        SurveyRadioButtonWidget(
                          answer: answer.answer,
                          groupValue:  selectedRadioValue,
                          onTap: onTap ,
                        )
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment : WrapAlignment.start,
                          children: buttons,
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            isShowResult = true;
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 30.w , right: 30.w),
                            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(5.r)
                            ),
                            child: Center(
                              child: Text(
                                "결과 확인하기",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            )
                        ),
                      ),
                    ],
                  );
                }
              }
            ),
          )
        ],
      ),
    );
  }
}

class SurveyRadioButtonWidget extends StatelessWidget {
  const SurveyRadioButtonWidget({super.key, required this.answer, required this.groupValue, required this.onTap});
  final String answer;
  final String? groupValue;
  final Function(String?) onTap;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          value: answer,
          groupValue: groupValue,
          onChanged: (value) {
            onTap(value);
          },
        ),
        Text(answer),
      ],
    );
  }
}


