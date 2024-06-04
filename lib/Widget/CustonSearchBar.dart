import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({super.key});

  final String hintText = "원하는 정보를 빨리 탐색 할 수 있어요.";

  final kGradientBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(
        colors: [Palette.defaultSkyBlue, Color(0xffFF9C32)]),
    borderRadius: BorderRadius.circular(20),
  );


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kGradientBoxDecoration,
      height: 40.w,
      child: Padding(
        padding: EdgeInsets.all(1.5.sp),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 6.w),
                child: SizedBox(
                  width: 13.sp,
                  height: 13.sp,
                  child: Image(
                    image: const AssetImage(
                      SearchBarImages.search
                    ),
                    height: 13.sp,
                    width: 13.sp,
                  ),
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 25.sp,
                minHeight: 25.sp,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20.r),
              ),
              hintStyle: TextStyle(
                color: const Color(0xffD9D9D9),
                fontSize: 11.sp
              )
            ),
          ),
        ),
      ),
    );
  }
}
