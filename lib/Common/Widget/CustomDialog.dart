import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog{
  static DialogRoute show({
    required Widget Function(BuildContext) builder,
    required BuildContext context,
    double? height,
    double? width,
    bool barrierDismissible = true
  }){
    final route = DialogRoute(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) =>  UnconstrainedBox(
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
              child: builder(dialogContext),
            ),
          ),
        ),
      )
    );

    Navigator.of(context).push(route);

    return route;
  }

  static DialogRoute defaultDialog({
    required BuildContext context,
    required Function(BuildContext) onTap,
    required String title,
    required String buttonText,
    Size? buttonSize,
    double? height,
    double? width,
    TextStyle? buttonTextStyle,
    bool closedOnTap = true,
    bool barrierDismissible = true
  }){
    return CustomDialog.show(
        height: height,
        width: width,
        barrierDismissible: barrierDismissible,
        builder: (dialogContext){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
                InkWell(
                  onTap: ()  {
                    if(closedOnTap && dialogContext.mounted){
                      Navigator.pop(context);
                    }
                    onTap(dialogContext);
                  },
                  child: Container(
                    width: buttonSize?.width ?? 75.w,
                    height:  buttonSize?.height ?? 25.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Theme.of(dialogContext).primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        buttonText,
                        style: buttonTextStyle ?? TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        context: context
    );
  }
}