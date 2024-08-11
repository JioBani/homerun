import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:gap/gap.dart';


///선택 박스 위젯
class SelectBoxWidget<T> extends StatefulWidget {
  const SelectBoxWidget({
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
    this.hasIcon = true
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

  @override
  State<SelectBoxWidget<T>> createState() => SelectBoxWidgetState<T>();
}

class SelectBoxWidgetState<T> extends State<SelectBoxWidget<T>> {
  bool isSelected = false;

  @override
  void initState() {
    widget.controller.addWidget(this);
    super.initState();
  }

  void changeSelect(bool select){
    setState(() {
      isSelected = select;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.iconPadding ?? EdgeInsets.zero,
      child: Ink( //#. InkWell의 클릭 애니메이션이 보이도록 하기 위해 사용
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular( widget.height ?? 40.w),
          color : const Color(0xffFBFBFB),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular( widget.height ?? 40.w),
          onTap: (){
            if(widget.controller.isCanSelectMulti){
              if(isSelected || widget.controller.values.length < 3){
                isSelected = !isSelected;
                setState(() { });
                widget.controller.onTap(this, isSelected);
              }
              else{
                CustomSnackbar.show("오류", "관심 지역은 최대 3개까지 선택 가능합니다.");
              }
            }
            else{
              isSelected = !isSelected;
              setState(() { });
              widget.controller.onTap(this, isSelected);
            }
          },
          child: Container(
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
          ),
        ),
      ),
    );
  }
}

class SelectBoxController<T>{
  /// 선택한 값
  T? value;

  /// 복수선택 가능시 선택한 값들
  List<T> values = [];

  /// 버튼 위젯들
  List<SelectBoxWidgetState<T>> widgets = [];

  /// 복수 선택 가능한지
  final bool isCanSelectMulti;

  SelectBoxController({this.isCanSelectMulti = false});

  /// 위젯 추가
  void addWidget(SelectBoxWidgetState<T> widget){
    widgets.add(widget);
  }

  /// 버튼 클릭시
  void onTap(SelectBoxWidgetState<T> widget, bool select){
    if(select){
      if(isCanSelectMulti){
        values.add(widget.widget.value);
      }
      else{
        value = widget.widget.value;
        for (var element in widgets) {
          if(element.widget.value != value){
            element.changeSelect(false);
          }
        }
      }
    }
    else{
      if(isCanSelectMulti){
        values.remove(widget.widget.value);
      }
      else{
        value = null;
      }
    }
  }
}