

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentInputWidget extends StatelessWidget {
  CommentInputWidget({super.key});

  final TextEditingController _controller = TextEditingController();

  void _submitComment() {
    if (_controller.text.isNotEmpty) {
      print('Submitted comment: ${_controller.text}');
      _controller.clear();
    }
  }

  final String hintText = "댓글을 입력해주세요.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.5.sp),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xffFBFBFB),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: TextFormField(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 7.5.sp , bottom: 7.5.sp,left: 7.5.w),
              hintText: hintText,
              isCollapsed: true,
              isDense :true,
              filled: true,
              //fillColor: Colors.redAccent,
              fillColor: Color(0xffFBFBFB),
              hintStyle: TextStyle(
                  fontSize: 11.sp,
                  color: Color(0xff767676)
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffA4A4A6) , width: 0.5.sp),
                borderRadius: BorderRadius.circular(3.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffA4A4A6) , width: 0.5.sp),
                borderRadius: BorderRadius.circular(3.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffA4A4A6) , width: 0.5.sp),
                borderRadius: BorderRadius.circular(3.r),
              )
          ),
          style: TextStyle(
              fontSize: 11.sp
          ),
          minLines: 1,
          maxLines: null, // Allow the TextFormField to grow dynamically
        ),
      ),
    );
  }
}