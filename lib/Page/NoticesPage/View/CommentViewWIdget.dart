import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:intl/intl.dart';

class CommentViewWidget extends StatelessWidget {
  const CommentViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: ListView(
        children: [
          CommentWidget(comment: Comment.test(),),
          SizedBox(height: 10.w,),
          CommentWidget(comment: Comment.test(),),
          SizedBox(height: 10.w,),
          CommentWidget(comment: Comment.test(),),
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
            SizedBox(width: 6.w,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.displayName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff767676)
                  ),
                ),
                Text(
                  DateFormat('yyyy.MM.dd').format(comment.date.toDate()),
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xff767676)
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(height: 7.w,),
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
              onTap: (){},
            ),
            CommentIconButton(
              imagePath: NoticePageImages.comment.bad,
              content: '134',
              onTap: (){},
            ),
            CommentIconButton(
              imagePath: NoticePageImages.comment.reply,
              content: '댓글 3',
              onTap: (){},
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
          SizedBox(width: 2.w,),
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


