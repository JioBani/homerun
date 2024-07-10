import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/Palette.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({super.key, required this.noticeId, required this.onFocus});
  final String noticeId;
  final void Function() onFocus;

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(_toggleOpen);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_toggleOpen);
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleOpen() {
    setState(() {
      if(_focusNode.hasFocus){
        widget.onFocus();
      }
    });
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );


  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: TextEditingController(),
      cursorColor: const Color(0xFF35C5F0),
      maxLines: _focusNode.hasFocus ? 6 : 1,
      focusNode: _focusNode,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0x00FBFBFB),
        hintText: ' 댓글을 입력해주세요.',
        hintStyle: TextStyle(color: Palette.brightMode.lightText , fontSize: 14.sp),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3.r),
          borderSide: BorderSide(color: Palette.brightMode.lightText,width: 1.sp),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3.r),
          borderSide: BorderSide(color: Palette.brightMode.lightText,width: 1.sp),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 6.w),
      ),
      style: TextStyle(
          fontSize: 14.sp,
          color: Palette.brightMode.mediumText
      ),
    );
  }
}