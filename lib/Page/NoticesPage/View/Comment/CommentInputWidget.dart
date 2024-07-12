import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Controller/ReplyCommentListContoller.dart';
import 'package:homerun/Style/Palette.dart';

import 'CommentSnackbar.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({
    super.key,
    required this.noticeId,
    required this.onFocus,
    this.replyTarget,
    this.startString,
    this.startWithOpen = false,
    this.isModify = false,
    this.maintainButtons = false,
    this.onPressClosed,
  });

  final String noticeId;
  final void Function() onFocus;
  final Comment? replyTarget;
  final String? startString;
  final bool startWithOpen;
  final bool isModify;
  final bool maintainButtons;
  final Function? onPressClosed;

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    _focusNode.addListener(_toggleOpen);
    if(widget.startString != null){
      textEditingController.text = widget.startString!;
    }
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
          autofocus: widget.startWithOpen,
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
            if(_focusNode.hasFocus || widget.maintainButtons){
              if(widget.isModify){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButtonWidget(
                      text: "취소",
                      width: 50.w,
                      height: 25.w,
                      onPressed: () {
                        widget.onPressClosed?.call();
                      },
                    ),
                    SizedBox(width: 5.w,),
                    CustomButtonWidget(
                      text: "등록",
                      width: 50.w,
                      height: 25.w,
                      onPressed: () async {
                        if(textEditingController.text.isEmpty){
                          Get.snackbar('알림','내용을 입력해주세요.');
                        }
                        else{

                          Result<Comment> result;

                          if(widget.replyTarget ==null){
                            result = await Get.find<CommentViewWidgetController>(tag: widget.noticeId)
                                .uploadComment(textEditingController.text);
                          }
                          else{
                            result = await Get.find<ReplyCommentWidgetController>(
                                tag: ReplyCommentWidgetController.makeTag(widget.noticeId, widget.replyTarget!.id))
                                .upload(textEditingController.text);
                          }

                          if(result.isSuccess){
                            _focusNode.unfocus();
                          }

                          CommentSnackbar.show(
                              result.isSuccess ? "알림" : "오류",
                              result.isSuccess ? "댓글을 등록했습니다." : "댓글 등록에 실패했습니다."
                          );
                        }
                      },
                    )
                  ],
                );
              }
              else{
                return CustomButtonWidget(
                  text: "등록",
                  width: 50.w,
                  height: 25.w,
                  onPressed: () async {
                    if(textEditingController.text.isEmpty){
                      Get.snackbar('알림','내용을 입력해주세요.');
                    }
                    else{

                      Result<Comment> result;

                      if(widget.replyTarget ==null){
                        result = await Get.find<CommentViewWidgetController>(tag: widget.noticeId)
                            .uploadComment(textEditingController.text);
                      }
                      else{
                        result = await Get.find<ReplyCommentWidgetController>(
                            tag: ReplyCommentWidgetController.makeTag(widget.noticeId, widget.replyTarget!.id))
                            .upload(textEditingController.text);
                      }

                      if(result.isSuccess){
                        _focusNode.unfocus();
                      }

                      CommentSnackbar.show(
                          result.isSuccess ? "알림" : "오류",
                          result.isSuccess ? "댓글을 등록했습니다." : "댓글 등록에 실패했습니다."
                      );
                    }
                  },
                );
              }
            }
            else{
              return const SizedBox();
            }
          }),
        )
      ],
    );
  }
}

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height
  });

  final String text;
  final Function onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.w),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.r),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0 , vertical: 0)
          ),
          child: Text(
            text,
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
}
