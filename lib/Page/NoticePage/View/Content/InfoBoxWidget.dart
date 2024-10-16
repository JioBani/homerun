import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoBoxWidget extends StatelessWidget {
  const InfoBoxWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310.w,
      color: const Color(0xffE7F2FF),
      child: Container(
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: child,
      ),
    );
  }
}
