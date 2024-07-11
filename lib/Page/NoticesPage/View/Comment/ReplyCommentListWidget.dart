import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Controller/ReplyCommentListContoller.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentInputWidget.dart';
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
              if(controller.loadingState == LoadingState.success){
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
              else if(controller.loadingState == LoadingState.fail){
                return const Text("댓글을 불러 올 수 없습니다.");
              }
              else{
                return const CupertinoActivityIndicator();
              }
            }
        ),
        CommentInputWidget(noticeId: widget.noticeId,onFocus: (){},replyTarget: widget.comment,),
      ],
    );
  }
}
