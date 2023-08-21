import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Palette.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:styled_widget/styled_widget.dart';


import 'CategoryButtonWidget.dart';

class AssessmentSurveyPage extends StatefulWidget {
  const AssessmentSurveyPage({super.key});

  @override
  State<AssessmentSurveyPage> createState() => _AssessmentSurveyPageState();
}

class _AssessmentSurveyPageState extends State<AssessmentSurveyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: Column(
                children: [
                  Text("국민주택",
                    style: TextStyle(
                      fontSize: 40.w,
                      fontWeight: FontWeight.w600
                    ),
                  ),
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
                          Center(
                            child: Wrap(
                              spacing: 20.w,
                              children: [
                                CategoryButtonWidget(),
                                CategoryButtonWidget(),
                                CategoryButtonWidget(),
                                CategoryButtonWidget(),
                                CategoryButtonWidget(),
                                CategoryButtonWidget(),
                                CategoryButtonWidget(),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.w,),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 40.w, 0, 40.w),
                            decoration: BoxDecoration(
                              color: Palette.light,
                              borderRadius: BorderRadius.circular(10.w),
                              boxShadow: [ShadowPalette.defaultShadowLight]
                            ),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 200.w,
                                      height: 100.w,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent
                                      ),
                                    ),
                                    Container(
                                      width: 200.w,
                                      height: 100.w,
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                    Container(
                                      width: 200.w,
                                      height: 100.w,
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12.w),
                                        width: 600.w,
                                        height: 273.w,
                                        decoration: BoxDecoration(
                                          color: Colors.lightGreen,
                                          borderRadius: BorderRadius.circular(10.w)
                                        ),
                                        child: Text("청약 저축 기간은?"),
                                      ),
                                      Container(
                                        width: 185.w,
                                        height: 273.w,
                                      ).decorated(
                                          color: Colors.lightGreen,
                                          borderRadius: BorderRadius.circular(10.w)
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
          )
      ),
    );
  }
}
