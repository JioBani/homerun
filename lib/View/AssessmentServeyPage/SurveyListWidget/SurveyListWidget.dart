import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:logger/logger.dart';

import 'CheckBoxTableWidget.dart';

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
      child: ExpansionPanelList(
        animationDuration: Duration(milliseconds: 500),
        elevation: 4,
        children: [
          ExpansionPanel(
              headerBuilder: (context , isExpanded){
                return ListTile(
                  title: Text("청약 저축 기간",
                    style: TextStyle(
                        fontSize: 35.w,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  subtitle: Text("선택 안함"),
                );
              },
              body: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CheckBoxTableWidget(),
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
              ),
              isExpanded: controller.isExpanded[0],
              canTapOnHeader: true
          ),
          ExpansionPanel(
              headerBuilder: (context , isExpanded){
                return ListTile(
                  title: Text("청약 저축 기간",
                    style: TextStyle(
                        fontSize: 35.w,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  subtitle: Text("선택 안함"),
                );
              },
              body: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CheckBoxTableWidget(),
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
              ),
              isExpanded: controller.isExpanded[1],
              canTapOnHeader: true
          ),
          ExpansionPanel(
              headerBuilder: (context , isExpanded){
                return ListTile(
                  title: Text("청약 저축 기간",
                    style: TextStyle(
                        fontSize: 35.w,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  subtitle: Text("선택 안함"),
                );
              },
              body: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CheckBoxTableWidget(),
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
              ),
              isExpanded: controller.isExpanded[2],
              canTapOnHeader: true
          ),
        ],
        expansionCallback: (int index, bool isExpanded) {
          for(int i = 0; i< controller.isExpanded.length; i++){
            controller.isExpanded[i] = false;
          }
          controller.isExpanded[index] = !isExpanded;

          Logger().i("$index , $isExpanded");
          setState(() {

          });
        },
      ),
    );
  }
}
