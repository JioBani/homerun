import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/AssessmentServeyPage/AssessmentServeyPage.dart';

class CategoryButtonWidget extends StatelessWidget {
  const CategoryButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(AssessmentSurveyPage());
        },
      child: Container(
        width: 250.w,
        height: 350.w,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20.w),
            boxShadow: [ShadowPalette.defaultShadow]
        ),
        child: Image.asset("assets/images/Ahri_15.jpg"),
      ),
    );
  }
}
