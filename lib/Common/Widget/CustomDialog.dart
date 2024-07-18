import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomDialog{
  static show({
    required Widget Function(BuildContext) builder,
    required BuildContext context,
    double? height,
    double? width,
  }){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: width ?? 200.w,
            height: height ?? 100.w,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: SizedBox(
                width: width ?? 200.w,
                height: height ?? 100.w,
                child: builder(context),
              ),
            ),
          ),
        );
      },
    );
  }
}