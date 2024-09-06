import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Style/Images.dart';

class SubTitleWidget extends StatelessWidget {
  const SubTitleWidget({super.key, required this.text,required this.frontPadding,});
  final double frontPadding;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.w,
      width: 260.w,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Image.asset(
            NoticePageImages.subTitleTextDecoration,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(frontPadding),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                    color: Colors.white
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}