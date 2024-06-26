import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
import 'package:homerun/Page/NoticesPage/Service/CommentService.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:intl/intl.dart';

import 'CommentInputWidget.dart';

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
    ).resendLoader.load();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          CommentInputWidget(noticeId: widget.noticeId),
          SizedBox(height: 20.w,),
          GetBuilder<CommentViewWidgetController>(
              tag: widget.noticeId,
              builder: (controller){
                if(controller.resendLoader.loadingState == LoadingState.success){
                  return Column(
                    children: controller.resendLoader.comments.map(
                            (comment) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.w),
                            child: CommentWidget(comment: comment, noticeId: widget.noticeId,)
                        )
                    ).toList(),
                  );
                }
                else{
                  return const CupertinoActivityIndicator();
                }
              }
          )
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.comment, required this.noticeId});

  final Comment comment;
  final String noticeId;

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
            ),
            const Expanded(child: SizedBox()),
            Builder(
                builder: (context){
                  if(FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.uid == comment.uid){
                    return TextButton(
                        onPressed: () async {
                          await CommentService().delete(noticeId, comment.commentId);
                        },
                        child: const Text('삭제')
                    );
                  }
                  else{
                    return const SizedBox();
                  }
                }
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
              onTap: () {
                //Get.find<CommentService>().likeComment(noticeId, comment.commentId);
              },
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
          InkWell(
            onTap: (){onTap();},
            child: Image.asset(
              imagePath,
              width: 9.5.sp,
              height: 9.5.sp,
            ),
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
