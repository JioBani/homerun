import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeProfileWidget extends StatelessWidget {
  const NoticeProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.w,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 5.w, 0, 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.r),
        color: Color(0xffA4A4A6),
      ),
    );
  }
}
