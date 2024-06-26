import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Service/CommentService.dart';
import 'package:homerun/Style/TestImages.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> with TickerProviderStateMixin {
  bool _isFormVisible = false;
  Widget hintTextWidget = const CommentHintTextWidget();
  late Widget inputFormWidget =  CommentInputFormWidget(noticeId: widget.noticeId,);
  late Widget child;

  @override
  void initState() {
    child = hintTextWidget;
    super.initState();
  }

  void _toggleFormVisibility() {
    setState(() {
      _isFormVisible = !_isFormVisible;
      if(_isFormVisible){
        child = inputFormWidget;
      }
      else{
        child = hintTextWidget;
      }
    });
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _toggleFormVisibility();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: const Color(0xffFBFBFB),
          border: Border.all(color: const Color(0xffA4A4A6)),
        ),
        child: AnimatedCrossFade(
          duration: _controller.duration!,
          firstCurve: Curves.bounceInOut,
          secondCurve: Curves.bounceInOut,
          firstChild: hintTextWidget,
          secondChild: inputFormWidget,
          crossFadeState: _isFormVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ),
    );
  }
}

class CommentHintTextWidget extends StatelessWidget {
  const CommentHintTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text("댓글을 입력해주세요."),
        Spacer(),
        Text("등록")
      ],
    );
  }
}


class CommentInputFormWidget extends StatefulWidget {
  const CommentInputFormWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<CommentInputFormWidget> createState() => _CommentInputFormWidgetState();
}

class _CommentInputFormWidgetState extends State<CommentInputFormWidget> {
  final CommentService commentService = CommentService();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.w),
              child: Image.asset(
                TestImages.ashe_43,
                width: 30.w,
                height: 30.w,
              ),
            ),
            SizedBox(width: 6.w,),
            Text(
              '고향은 서울',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xff767676)
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                if(textEditingController.text.isNotEmpty){
                  // Result result = await commentService.uploadComment(textEditingController.text, widget.noticeId);
                  // if(result.isSuccess){
                  //   Get.find<CommentViewWidgetController>(tag: widget.noticeId).loadCommentsByPopularity();
                  // }
                  Get.find<CommentViewWidgetController>(tag: widget.noticeId).uploadComment(textEditingController.text);
                }
                else{

                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Theme.of(context).primaryColor
                ),
                width: 50.w,
                height: 20.w,
                child: Center(
                  child: Text(
                    "등록",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 8.w,),
        TextFormField(
          controller: textEditingController,
          maxLines: 6,
          cursorColor: const Color(0xFF35C5F0),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0x00FBFBFB),
            hintText: '서로 곱고 아름다운 말을 사용해주세요 :-)',
            hintStyle: TextStyle(color: const Color(0xFFD9D9D9) , fontSize: 11.sp),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: const Color(0xFF35C5F0),width: 1.sp),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: const Color(0xFF35C5F0),width: 1.sp),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 6.w),
          ),
          style: TextStyle(
              fontSize: 11.sp
          ),
        ),
        SizedBox(height: 6.w,),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '0 / 3000',
            style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xff35C5F0)
            ),
          ),
        )
      ],
    );
  }
}