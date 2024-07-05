import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
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

    commentViewWidgetController.resendLoader.getNextComments(3, reset: true);

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
                if(controller.resendLoader.loadingState == LoadingState.success ||
                   controller.resendLoader.loadingState == LoadingState.noMoreData
                ){
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
                  return const SizedBox();
                }
              }
          ),
          GetBuilder<CommentViewWidgetController>(
              tag: widget.noticeId,
              builder: (controller){
                if(controller.resendLoader.loadingState == LoadingState.success){
                  return TextButton(
                      onPressed: (){
                        commentViewWidgetController.resendLoader.getNextComments(2);
                      },
                      child: Text('더보기')
                  );
                }
                else if(controller.resendLoader.loadingState == LoadingState.noMoreData){
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