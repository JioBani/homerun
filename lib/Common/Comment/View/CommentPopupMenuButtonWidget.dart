import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Model/Comment.dart';
import 'package:homerun/Common/Comment/Controller/CommentListController.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Controller/ReplyCommentListContoller.dart';
import 'package:homerun/Unused/CommentSnackbar.dart';

class CommentPopupMenuButtonWidget extends StatelessWidget {
  const CommentPopupMenuButtonWidget({
    super.key,
    required this.commentListController,
    required this.comment,
    required this.onTapModify,
    this.replyTarget,
    this.isMine = false
  });

  final Comment comment;
  final void Function() onTapModify;
  final Comment? replyTarget;
  final bool isMine;
  final CommentListController commentListController;

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
            commentListController.delete(comment);
          }
          else if(result == "수정"){
            onTapModify();
          }
        },
        itemBuilder: (BuildContext buildContext) {
          if(isMine){
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
          }
          else{
            return [
              buildMenuItem(
                value: "신고",
                name: "신고하기",
                icon: Icons.mode_edit_outline_outlined,
                color: Colors.black,
              )
            ];
          }
        },
        elevation: 4,
      ),
    );
  }
}


