import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Controller/ReplyCommentListContoller.dart';

import 'CommentSnackbar.dart';

class CommentPopupMenuButtonWidget extends StatelessWidget {
  const CommentPopupMenuButtonWidget({super.key,required this.noticeId ,required this.comment, this.replyTarget});
  final String noticeId;
  final Comment comment;
  final Comment? replyTarget;

  PopupMenuItem<String> buildMenuItem({
    required String value,
    required String name,
    required IconData icon,
    required Color color
  }){
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.zero,
      height: 32.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              //Icons.mode_edit_outline_outlined,
              size: 16.sp,
              color: color,
              weight: 0.1,
            ),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: color
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 20.sp,
      width: 20.sp,
      child: PopupMenuButton<String>(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert,
          size: 20.sp,
          color: const Color(0xffD9D9D9),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.r))
        ),
        onSelected: (String result) async {
          if(result == "삭제"){
            Result<void> result;
            if(replyTarget == null){
              result = await Get.find<CommentViewWidgetController>(
                  tag: noticeId
              ).deleteComment(comment);
            }
            else{
              result = await Get.find<ReplyCommentWidgetController>(
                  tag: ReplyCommentWidgetController.makeTag(noticeId, replyTarget!.id))
                  .delete(comment);
            }

            CommentSnackbar.show(
                result.isSuccess ? "알림" : "오류",
                result.isSuccess ? "댓글을 삭제했습니다." : "댓글 삭제에 실패했습니다."
            );
          }
          else if(result == "수정"){

          }
        },
        itemBuilder: (BuildContext buildContext) {
          return [
            buildMenuItem(
              value: "수정",
              name: "수정하기",
              icon: Icons.mode_edit_outline_outlined,
              color: Colors.black,
            ),
            buildMenuItem(
              value: "삭제",
              name: "삭제하기",
              icon: Icons.delete_outlined,
              color: Colors.redAccent
            ),
          ];
        },
        elevation: 4,
      ),
    );
  }
}


