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
      child: Row(
        children: [
          Column(
            children: [
              Text(
                "서울 (민간분양) | 조회수 3,245",
                style: TextStyle(
                  fontSize: 8.sp,
                ),
              )
            ],
          ),
          Column(),
        ],
      ),
    );
  }
}