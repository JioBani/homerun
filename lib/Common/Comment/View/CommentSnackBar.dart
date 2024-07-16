import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommentSnackbar{
  static void show(String title, String content){
    Get.snackbar(
      title,
      content,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.only(bottom: 20.w , left: 20.w , right: 20.w),
      duration: const Duration(milliseconds: 1500),
      animationDuration: const Duration(milliseconds: 750),
    );
  }
}