import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Style/Palette.dart';

import '../Value/SortType.dart';

///TODO
/// 정렬 이름 수정하기
/// 드롭다운 버튼 정렬 위치 선택하기
class SortDropDownButtonWidget extends StatefulWidget {
  const SortDropDownButtonWidget({super.key, required this.startValue, required this.onChanged});
  final SortType startValue;
  final Function(SortType) onChanged;

  @override
  State<SortDropDownButtonWidget> createState() => _SortDropDownButtonWidgetState();
}

class _SortDropDownButtonWidgetState extends State<SortDropDownButtonWidget> {
  late SortType? selectedValue = widget.startValue;

  PopupMenuItem<SortType> buildMenuItem({
    required SortType value,
    required String name,
    required IconData icon,
    required Color color
  }){
    return PopupMenuItem<SortType>(
      value: value,
      padding: EdgeInsets.zero,
      height: 32.h,
      child: SizedBox(
        width: 120.w,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Gap(10.w), //10
            Icon( // 26
              icon,
              size: 16.w,
              color: color,
              weight: 0.1,
            ),
            Gap(5.w), //31
            SizedBox( //101
              width: 70.w,
              child: AutoSizeText(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: Palette.brightMode.darkText
                ),
                maxLines: 1,
              ),
            ),
            Gap(10.w), //111
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortType>(
      constraints: BoxConstraints.tightFor(width: 120.w),
      surfaceTintColor: Colors.white,
      color: Colors.white,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.r))
      ),
      onSelected: (SortType result) async {
        setState(() {
          selectedValue = result;
        });
        widget.onChanged(result);
      },
      itemBuilder: (BuildContext buildContext) {
        return SortType.values.map((e)=>buildMenuItem(
          value: e,
          name: e.toEnumString(),
          icon: e == selectedValue ? Icons.check_circle_outline : Icons.circle_outlined,
          color: e == selectedValue ? Theme.of(context).primaryColor  :  Palette.brightMode.darkText
        )).toList();
      },
      elevation: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16.w,
            color: Theme.of(context).primaryColor,
            weight: 0.1,
          ),
          Gap(4.w),
          Text(
            selectedValue?.toEnumString() ?? "알 수 없음",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}