import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

class CustomSnackbar{

  static List<String> _snackBarKeys = [];

  static void show(
    String title,
    String content,
    {
      Duration duration =  const Duration(milliseconds: 1500),
      Duration animationDuration =  const Duration(milliseconds: 750),
      EdgeInsets? margin,
      String? key,
      bool avoidDuplication = false,
    })
  {
    if(avoidDuplication){
      if(key == null){
        throw Exception('중복 방지를 위해서는 키가 반드시 존재해야합니다.');
      }
      else{
        if(_snackBarKeys.contains(key)){
          return;
        }
        else{
          _snackBarKeys.add(key);

          SnackbarController snackbarController = Get.snackbar(
            title,
            content,
            snackPosition: SnackPosition.BOTTOM,
            margin: margin ?? EdgeInsets.only(bottom: 20.w , left: 20.w , right: 20.w),
            duration: duration,
            animationDuration: animationDuration,
          );

          snackbarController.future.then((value) => _snackBarKeys.remove(key));
        }
      }
    }
    else{
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
}