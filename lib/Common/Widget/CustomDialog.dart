import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Common/model/Result.dart';

//#. 확인 다이얼로그 제작하기
class CustomDialog{

  /// 명세

  /// Returns : 다이얼로그의 값과 DialogRoute를 포함한 [DialogResult]를 반환합니다.
  static DialogResult show<T>({
    required Widget Function(BuildContext) builder,
    required BuildContext context,
    double? height,
    double? width,
    double? maxHeight,
    double? maxWidth,
    EdgeInsets? margin,
    bool barrierDismissible = true
  }){
    final route = DialogRoute<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) =>  Container(
        constraints: BoxConstraints(
          minWidth: width ?? 200.w,
          minHeight: height ?? 100.w,
          maxWidth: maxWidth ?? 200.w,
          maxHeight: maxHeight ?? 100.w,
        ),
        margin: margin ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Container(
            constraints: BoxConstraints(
              minWidth: width ?? 200.w,
              minHeight: height ?? 100.w,
              maxWidth: maxWidth ?? 200.w,
              maxHeight: maxHeight ?? 100.w,
            ),
            child: builder(dialogContext),
          ),
        ),
      )
    );

    return DialogResult(Navigator.of(context).push(route) , route);
  }

  /// [onTap] 버튼을 누른 후 액션(다이얼로그가 닫힌 후 실행됨)
  ///
  /// [buttonGap] 텍스트와 버튼 사이의 간격
  /// Returns : 다이얼로그의 값과 DialogRoute를 포함한 [DialogResult]를 반환합니다.
  static DialogResult defaultDialog<T>({
    required BuildContext context,
    Function(BuildContext)? onTap,
    required String title,
    required String buttonText,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Size? buttonSize,
    double? height,
    double? width,
    double? maxHeight,
    double? maxWidth,
    TextStyle? buttonTextStyle,
    bool closedOnTap = true,
    bool barrierDismissible = true,
    double buttonGap = 0,
  }){
    return CustomDialog.show(
        height: height,
        width: width,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        barrierDismissible: barrierDismissible,
        margin : margin,
        builder: (dialogContext){
          return Padding(
            padding: padding ?? EdgeInsets.symmetric(vertical: 5.w , horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(buttonGap),
                InkWell(
                  onTap: ()  {
                    if(closedOnTap && dialogContext.mounted){
                      Navigator.pop(context);
                    }
                    if(onTap != null){
                      onTap(dialogContext);
                    }
                  },
                  child: Container(
                    width: buttonSize?.width ?? 75.w,
                    height:  buttonSize?.height ?? 25.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Theme.of(dialogContext).primaryColor,
                    ),
                    child: Center(
                      child: AutoSizeText(
                        buttonText,
                        style: buttonTextStyle ?? TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
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

  static Future<Result<T>> showLoadingDialog<T>({
    required BuildContext context ,
    required Future<T> future,
  }) async {
    final route = DialogRoute(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) =>  UnconstrainedBox(
            child:  Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white
              ),
              child: const CupertinoActivityIndicator(),
            )
          )
      );

    Navigator.of(context).push(route);

    Result<T> result = await Result.handleFuture<T>(action: ()=>future);

    if(context.mounted && route.canPop){
      Navigator.of(context).pop(route);
    }

    return result;
  }

  /// 확인 다이얼로그
  ///
  /// 확인 또는 취소 등의 2지선다 확인이 필요할때 사용합니다.
  ///
  /// [onConfirm] : 확인 버튼을 누른 경우 다이얼로그가 닫히고 실행됩니다.
  ///
  /// [returns] : confirm = true, cancel = false, backButton = null
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String content,
    Function()? onConfirm,
    TextStyle? contentTextStyle,
    String confirmText = "확인",
    String cancelText = "취소",
    Color? confirmTextColor,
    EdgeInsets? padding,
    TextAlign? contentAlignment,
  }){
    const Color borderColor = Color(0xffA4A4A6);

    final route = DialogRoute<bool>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) =>  Container(
          height: 114.w,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 35.w),
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: SizedBox(
              height: 114.w,
              width: double.infinity,
              child: Column(
                children: [
                  //#. 내용
                  Expanded(
                    child: Padding(
                      padding: padding ?? EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.w),
                      child: Center(
                        child: Text(
                          content,
                          textAlign : contentAlignment,
                          style: contentTextStyle ?? TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ),
                    )
                  ),
                  //#. 버튼
                  Row(
                    children: [
                      //#. 취소
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            if(dialogContext.mounted && Navigator.canPop(dialogContext)){
                              Navigator.pop(dialogContext , false);
                            }
                          },
                          child: Container(
                            height: 33.w,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 0.7.w,color: borderColor),
                                right: BorderSide(width: 0.35.w , color: borderColor),
                              )
                            ),
                            child: Center(
                              child: Text(
                                cancelText,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ),
                        ),
                      ),
                      //#. 확인
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            if(dialogContext.mounted && Navigator.canPop(dialogContext)){
                              Navigator.pop(dialogContext , true);
                            }

                            if(onConfirm != null){
                              onConfirm();
                            }
                          },
                          child: Container(
                            height: 33.w,
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(width: 0.7.w , color: borderColor),
                                  left: BorderSide(width: 0.35.w , color: borderColor),
                                )
                            ),
                            child: Center(
                              child: Text(
                                confirmText,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: confirmTextColor ?? Theme.of(context).primaryColor
                                ),
                              ),
                            )
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
    return Navigator.of(context).push<bool>(route);
  }
}

/// 커스텀 다이얼로그의 결과를 담는 객체입니다.
///
/// [result] : 다이얼로그의 결과값
///
/// [route] : DialogRoute
class DialogResult<T>{
  /// 다이얼로그의 결과값
  final Future<T?> result;

  /// 다이얼로그 루트
  final DialogRoute<T> route;

  DialogResult(this.result, this.route);
}