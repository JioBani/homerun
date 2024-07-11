import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/ReplyCommentListContoller.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentInputWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentSnackbar.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentWidget.dart';

class ReplyCommentListWidget extends StatefulWidget {
  const ReplyCommentListWidget({super.key, required this.noticeId, required this.comment});
  final String noticeId;
  final Comment comment;

  @override
  State<ReplyCommentListWidget> createState() => _ReplyCommentListWidgetState();
}

class _ReplyCommentListWidgetState extends State<ReplyCommentListWidget> {

  List<Comment> replyList = [];

  @override
  void initState() {
    Get.put(
        ReplyCommentWidgetController(
            noticeId: widget.noticeId,
            replyTarget: widget.comment
        ),
        tag: ReplyCommentWidgetController.makeTag(widget.noticeId, widget.comment.id)
    ).load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<ReplyCommentWidgetController>(
            tag: ReplyCommentWidgetController.makeTag(widget.noticeId, widget.comment.id),
            builder: (controller) {
              return Column(
                children: controller.replyList.map((reply) =>
                    CommentWidget(
                      comment: reply,
                      noticeId: widget.noticeId ,
                      replyTarget: widget.comment,
                    )
                ).toList(),
              );
            }
        ),
        GetBuilder<ReplyCommentWidgetController>(
            tag: ReplyCommentWidgetController.makeTag(widget.noticeId, widget.comment.id),
            builder: (controller) {
              if(controller.loadingState == LoadingState.noMoreData){
                return const SizedBox();
              }
              else if(controller.loadingState == LoadingState.loading){
                return const CupertinoActivityIndicator();
              }
              else{
                return TextButton(
                    onPressed: () async {
                      Result result = await controller.load();
                      if(!result.isSuccess){
                        CommentSnackbar.show("오류", "댓글을 불러 올 수 없습니다.");
                      }
                    },
                    child: const Text("더보기")
                );
              }
            }
        ),
        CommentInputWidget(noticeId: widget.noticeId,onFocus: (){},replyTarget: widget.comment,),
      ],
    );
  }
}
