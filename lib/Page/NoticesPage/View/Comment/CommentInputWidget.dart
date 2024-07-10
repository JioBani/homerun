import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Style/Palette.dart';

import 'CommentSnackbar.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({super.key, required this.noticeId, required this.onFocus});
  final String noticeId;
  final void Function() onFocus;

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        TextFormField(
          controller: textEditingController,
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
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Builder(builder: (context){
            if(_focusNode.hasFocus){
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 3.w),
                child: SizedBox(
                  width: 50.w,
                  height: 25.w,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(textEditingController.text.isEmpty){
                        Get.snackbar('알림','내용을 입력해주세요.');
                      }
                      else{
                        Result<Comment> result = await Get.find<CommentViewWidgetController>(tag: widget.noticeId)
                            .uploadComment(textEditingController.text);

                        if(result.isSuccess){
                          _focusNode.unfocus();
                        }

                        CommentSnackbar.show(
                            result.isSuccess ? "알림" : "오류",
                            result.isSuccess ? "댓글을 등록했습니다." : "댓글 등록에 실패했습니다."
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 0 , vertical: 0)
                    ),
                    child: Text(
                      "등록",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp
                      ),
                    ),
                  ),
                ),
              );
            }
            else{
              return SizedBox();
            }
          }),
        )
      ],
    );
  }
}