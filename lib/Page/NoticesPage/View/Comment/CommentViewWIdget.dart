import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/CommentService.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentLoader.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'CommentInputWidget.dart';
import 'CommentWidget.dart';

class CommentViewWidget extends StatefulWidget {
  const CommentViewWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<CommentViewWidget> createState() => _CommentViewWidgetState();
}

class _CommentViewWidgetState extends State<CommentViewWidget> {

  late final CommentViewWidgetController commentViewWidgetController;

  @override
  void initState() {
    commentViewWidgetController = Get.put(
        tag:widget.noticeId,
        CommentViewWidgetController(noticeId: widget.noticeId)
    );

    commentViewWidgetController.loadComment(NoticeCommentType.free, OrderType.date).then((value) => {
      StaticLogger.logger.i(value.isSuccess)
    });

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
                CommentLoader commentLoader =  commentViewWidgetController.getCommentLoader(NoticeCommentType.free, OrderType.date);
                if(commentLoader.loadingState == LoadingState.success ||
                    commentLoader.loadingState == LoadingState.noMoreData
                ){
                  return Column(
                    children: commentLoader.comments.map(
                            (comment) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.w),
                            child: CommentWidget(comment: comment, noticeId: widget.noticeId,)
                        )
                    ).toList(),
                  );
                }
                else{
                  return const SizedBox();
                }
              }
          ),
          GetBuilder<CommentViewWidgetController>(
              tag: widget.noticeId,
              builder: (controller){
                CommentLoader commentLoader =  commentViewWidgetController.getCommentLoader(NoticeCommentType.free, OrderType.date);
                if(commentLoader.loadingState == LoadingState.success){
                  return TextButton(
                      onPressed: (){
                        commentLoader.getComments(2);
                      },
                      child: Text('더보기')
                  );
                }
                else if(commentLoader.loadingState == LoadingState.noMoreData){
                  return Text("마지막 댓글 입니다.");
                }
                else{
                  return Text("댓글을 불러 올 수 없습니다.");
                }
              }
          ),
        ],
      ),
    );
  }
}