import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
import 'package:homerun/Page/NoticesPage/View/CommentInputWidget.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:intl/intl.dart';

class CommentViewWidget extends StatefulWidget {
  const CommentViewWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<CommentViewWidget> createState() => _CommentViewWidgetState();
}

class _CommentViewWidgetState extends State<CommentViewWidget> {

  @override
  void initState() {
    Get.put(
        tag:widget.noticeId,
        CommentViewWidgetController(noticeId: widget.noticeId)
    ).loadComments();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          CommentInputWidget(noticeId: widget.noticeId,),
          SizedBox(height: 20.w,),
          GetX<CommentViewWidgetController>(
            tag: widget.noticeId,
            builder: (controller){
              if(controller.loadingState.value == LoadingState.success){
                return Column(
                  children: controller.comments.map(
                        (comment) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.w),
                          child: CommentWidget(comment: comment,)
                        )
                  ).toList(),
                );
              }
              else if(controller.loadingState.value == LoadingState.fail){
                return Text('오류');
              }
              else{
                return CupertinoActivityIndicator();
              }
            }
          )
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(
              width: 6.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.displayName,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: const Color(0xff767676)),
                ),
                Text(
                  DateFormat('yyyy.MM.dd').format(comment.date.toDate()),
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.normal, color: const Color(0xff767676)),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 7.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text(
            comment.content,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CommentIconButton(
              imagePath: NoticePageImages.comment.good,
              content: '300',
              onTap: () {},
            ),
            CommentIconButton(
              imagePath: NoticePageImages.comment.bad,
              content: '134',
              onTap: () {},
            ),
            CommentIconButton(
              imagePath: NoticePageImages.comment.reply,
              content: '댓글 3',
              onTap: () {},
            ),
          ],
        )
      ],
    );
  }
}

class CommentIconButton extends StatelessWidget {
  const CommentIconButton({super.key, required this.content, required this.onTap, required this.imagePath});

  final String content;
  final Function onTap;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 9.5.sp,
            height: 9.5.sp,
          ),
          SizedBox(
            width: 2.w,
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                content, // Example text
                style: TextStyle(
                  fontSize: 9.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
