import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Controller/ReplyCommentListContoller.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
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
    // TODO: implement initState
    Get.put(
        ReplyCommentWidgetController(
            noticeId: widget.noticeId,
            targetCommentId: widget.comment.commentId
        ),
        tag: "${widget.noticeId}/${widget.comment.commentId}"
    ).load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ReplyCommentWidgetController>(
        tag: "${widget.noticeId}/${widget.comment.commentId}",
        builder: (controller) {
          if(controller.loadingState.value == LoadingState.success){
            return Column(
              children: controller.replyList.map((reply) =>
                  CommentWidget(
                    comment: reply,
                    noticeId: widget.noticeId ,
                    replyTarget: widget.comment.commentId,
                  )
              ).toList(),
            );
          }
          else if(controller.loadingState.value == LoadingState.fail){
            return const Text("댓글을 불러 올 수 없습니다.");
          }
          else{
            return const CupertinoActivityIndicator();
          }
        }
    );
  }
}
