import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/SelectBoxWidget.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:gap/gap.dart';


///선택 박스 위젯
class UserInfoSelectBoxWidget<T> extends StatefulWidget {
  const UserInfoSelectBoxWidget({
    super.key,
    required this.value,
    required this.width,
    this.height,
    required this.text,
    required this.onTap,
    this.letterSpacing,
    required this.controller,
    this.iconPadding,
    this.textPadding,
    this.hasIcon = true,
    this.maxSelectCount
  });

  final T value;
  final double width;
  final double? height;
  final String text;
  final Function(T value) onTap;
  final double? letterSpacing;
  final SelectBoxController<T> controller;
  final EdgeInsets? iconPadding;
  final EdgeInsets? textPadding;
  final bool hasIcon;
  final int? maxSelectCount;

  @override
  State<UserInfoSelectBoxWidget<T>> createState() => UserInfoSelectBoxWidgetState<T>();
}

class UserInfoSelectBoxWidgetState<T> extends State<UserInfoSelectBoxWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.iconPadding ?? EdgeInsets.zero,
      child: Ink( //#. InkWell의 클릭 애니메이션이 보이도록 하기 위해 사용
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular( widget.height ?? 40.w),
          color : const Color(0xffFBFBFB),
        ),
        child: SelectBoxWidget<T>(
          value: widget.value,
          controller: widget.controller,
          inkWellBorderRadius: BorderRadius.circular( widget.height ?? 40.w),
          onSelectCountOverFlow: (_,value,count){
            CustomDialog.showConfirmationDialog(
                context: context,
                content: "최대 ${widget.controller.maxSelectCount}개 까지 선택 가능합니다."
            );
          },
          builder: (_,value,isSelected){
            return Container(
              width: widget.width,
              height: widget.height ?? 40.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.height ?? 40.w),
                  border: isSelected ? GradientBoxBorder(
                      gradient: Gradients.skyBlueOrange,
                      width: 1.5.w
                  ) :
                  Border.all(color: const Color(0xffD9D9D9) , width: 0.5.w)
              ),
              child: Builder(
                  builder: (context) {
                    if(widget.hasIcon){
                      return Row(
                        children: [
                          Gap(10.w),
                          Icon(
                            Icons.check_circle,
                            color: isSelected ? Palette.defaultOrange : const Color(0xffD9D9D9),
                            size: 20.sp,
                          ),
                          Expanded(
                            child: Padding(
                              padding: widget.textPadding ?? EdgeInsets.only(left: 3.w,right: 10.w),
                              child: AutoSizeText(
                                widget.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: Palette.brightMode.mediumText,
                                  letterSpacing : widget.letterSpacing,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    else{
                      return Center(
                        child: Padding(
                          padding: widget.textPadding ?? EdgeInsets.only(left: 10.w,right: 10.w),
                          child: AutoSizeText(
                            widget.text,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: Palette.brightMode.mediumText,
                              letterSpacing : widget.letterSpacing,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      );
                    }
                  }
              ),
            );
          },
        ),
      ),
    );
  }
}