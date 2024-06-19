import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/NoticesPage/Service/CommentService.dart';

class CommentInputWidget extends StatelessWidget {
  CommentInputWidget({super.key, required this.noticeId});
  final String noticeId;

  final TextEditingController _controller = TextEditingController();

  Future<void> _submitComment() async {
    try{
      //await CommentService().delete(noticeId,'f2Y7kbN9sV4Aj2mbyeUL');
      if(_controller.text.isNotEmpty){
        await CommentService().uploadComment(_controller.text,noticeId);
      }
    }catch(e){
      StaticLogger.logger.e(e);
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
          controller: _controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 7.5.sp , bottom: 7.5.sp,left: 7.5.w),
              hintText: hintText,
              isDense :true,
              filled: true,
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
              ),
              suffixIcon: InkWell(
                onTap: _submitComment,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '등록',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  ),
                ),
              ),
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