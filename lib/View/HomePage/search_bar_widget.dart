import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hintText = "원하는 정보를 빨리 탐색 할 수 있어요.";

  const CustomTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
      child: SizedBox(
        height: 35.w,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              //borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.r),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}





