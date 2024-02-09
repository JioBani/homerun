import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:homerun/Model/SurveyData.dart';
import 'package:homerun/View/DubleTapExitWidget.dart';
import 'package:homerun/View/SaleInfomation/PresaleInfo/SurveyWidget.dart';
import 'package:homerun/View/buttom_nav.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PresaleInfoPage extends StatelessWidget {
  const PresaleInfoPage({super.key, required this.preSaleData});
  final PreSaleData preSaleData;

  @override
  Widget build(BuildContext context) {
    return DoubleTapExitWidget(
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  width: double.infinity,
                  height: 500.h,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent
                  ),
                ),
                SizedBox(height: 40.h,),
                SurveyListWidget(surveyData: preSaleData.surveyData,),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
        )
    );
  }
}
