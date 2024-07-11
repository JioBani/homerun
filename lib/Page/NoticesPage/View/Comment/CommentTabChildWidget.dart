import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentLoader.dart';

import '../../Controller/CommentViewWidgetController.dart';
import 'CommentWidget.dart';

class CommentTabChildWidget extends StatelessWidget {
  const CommentTabChildWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 200.w,
      ),
      child: Column(
        children: [
          GetBuilder<CommentViewWidgetController>(
              tag: noticeId,
              builder: (controller){
                CommentLoader commentLoader =  controller.showLoader;
                if(commentLoader.loadingState == LoadingState.success ||
                    commentLoader.loadingState == LoadingState.noMoreData
                ){
                  return Column(
                    children: commentLoader.comments.map((comment) =>
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        child: CommentWidget(comment: comment, noticeId: noticeId,)
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
              tag: noticeId,
              builder: (controller){
                CommentLoader commentLoader =  controller.showLoader;
                if(commentLoader.loadingState == LoadingState.success){
                  return TextButton(
                      onPressed: (){
                        controller.loadComment();
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
