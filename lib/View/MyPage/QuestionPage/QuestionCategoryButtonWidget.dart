import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/ShadowPalette.dart';

class QuestionCategoryButtonWidget extends StatelessWidget {
  const QuestionCategoryButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black45,
            width: 0.5
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [ShadowPalette.defaultShadowLight]
      ),
      width: 180.w,
      height: 100.h,
      child: Center(
        child: Text(
          "테스트",
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
