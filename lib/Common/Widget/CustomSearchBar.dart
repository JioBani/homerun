import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  final String hintText = "원하는 정보를 빨리 탐색 할 수 있어요.";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 0),
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
              border: GradientOutlineInputBorder(
                gradient: const LinearGradient(colors: [Palette.defaultSkyBlue, Color(0xffFF9C32)]),
                width: 2.w,
                borderRadius: BorderRadius.circular(20.r),
              ),
              hintStyle: TextStyle(
                  color: const Color(0xffD9D9D9),
                  fontSize: 11.sp
              )
          ),
        ),
      ],
    );
  }
}
