
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';
import 'package:homerun/Page/NoticeSearchPage/Controller/TagSearchBarController.dart';
import 'package:homerun/Style/Palette.dart';

class SelectButton<T> extends StatefulWidget {
  const SelectButton({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    required this.controller,
  });

  final T value;
  final String text;
  final Function(bool selected, T value , SelectButtonState<T> state) onChanged;  // 타입 명확히 지정
  final TagSearchBarController controller;

  @override
  State<SelectButton> createState() => SelectButtonState<T>();
}

class SelectButtonState<T> extends State<SelectButton<T>> {  // 제네릭 T를 확실히 사용
  bool selected = false;

  void setValue(bool select){
    selected = select;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 90.w),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.w),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(40.w),
            onTap: () {
              if(!selected && widget.value is Region && widget.controller.regionTags.length > 9){
                CustomSnackbar.show("알림", "지역은 최대 10개까지 선택 할 수 있습니다.");
                return;
              }

              selected = !selected;
              setState(() {});
              widget.onChanged(selected, widget.value , this);  // 타입 일치
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.w),
                color: selected ? Theme.of(context).primaryColor : Palette.baseColor,
                border: Border.all(
                  color: selected ? Theme.of(context).primaryColor : Palette.brightMode.mediumText,
                  width: 0.1.sp
                ),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: selected ? Colors.white : Palette.brightMode.darkText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
