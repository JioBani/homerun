import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomSnackbar{
  static void show(
    String title,
    String content,
    {
      Duration duration =  const Duration(milliseconds: 1500),
      Duration animationDuration =  const Duration(milliseconds: 750),
      EdgeInsets? margin
    })
  {
    Get.snackbar(
      title,
      content,
      snackPosition: SnackPosition.BOTTOM,
      margin: margin ?? EdgeInsets.only(bottom: 20.w , left: 20.w , right: 20.w),
      duration: duration,
      animationDuration: animationDuration,
    );
  }
}