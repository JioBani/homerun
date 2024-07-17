import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Model/Comment.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Style/Palette.dart';

import '../Controller/ReplyCommentListWidgetController.dart';
import 'CommentInputWidget.dart';
import 'CommentSnackBar.dart';
import 'CommentWidget.dart';

class ReplyCommentListWidget extends StatefulWidget {
  const ReplyCommentListWidget({super.key, required this.replyParentComment});
  final Comment replyParentComment;

  @override
  State<ReplyCommentListWidget> createState() => _ReplyCommentListWidgetState();
}

class _ReplyCommentListWidgetState extends State<ReplyCommentListWidget> {

  List<Comment> replyList = [];
  late final ReplyCommentListWidgetController controller;

  @override
  void initState() {
    controller = Get.put(
        ReplyCommentListWidgetController(
          replyTarget: widget.replyParentComment,
          hasLikes: true
        ),
        tag: widget.replyParentComment.id
    );

    controller.commentController.load(ReplyCommentListWidgetController.commentsPerLoad);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 7.5.w),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(
              color: Palette.brightMode.lightText,
              width: 1.w
          ))
      ),
      child: Column(
        children: [
          GetBuilder<ReplyCommentListWidgetController>(
              tag: widget.replyParentComment.id,
              builder: (controller) {
                return Column(
                  children: controller.commentController.comments.map((reply) =>
                      CommentWidget(
                        commentController: controller.commentController,
                        replyTarget: widget.replyParentComment,
                        comment: reply,
                      )
                  ).toList(),
                );
              }
          ),
          GetBuilder<ReplyCommentListWidgetController>(
              tag: widget.replyParentComment.id,
              builder: (controller) {
                if(controller.commentController.loadingState == LoadingState.noMoreData){
                  return const SizedBox();
                }
                else if(controller.commentController.loadingState == LoadingState.loading){
                  return const CupertinoActivityIndicator();
                }
                else{
                  return TextButton(
                      onPressed: () async {
                        Result result = await controller.commentController.load(
                            ReplyCommentListWidgetController.commentsPerLoad
                        );
                        if(!result.isSuccess){
                          CommentSnackbar.show("오류", "댓글을 불러 올 수 없습니다.");
                        }
                      },
                      child: const Text("더보기")
                  );
                }
              }
          ),
          CommentInputWidget(
            onTapSubmit: (context , content , focusNode , textController) async {
              Result? result = await controller.commentController.upload(content , replyTarget: widget.replyParentComment);
              if(result != null && result.isSuccess){
                textController.clear();
                focusNode.unfocus();
              }
            },
            maintainButtons : true,
          ),
        ],
      ),
    );
  }
}
