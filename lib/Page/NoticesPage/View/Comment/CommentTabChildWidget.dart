import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/View/CommentWidget.dart';
import 'package:homerun/Common/LoadingState.dart';

import '../../Controller/CommentViewWidgetController.dart';

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
          //#. 댓글 리스트
          GetBuilder<CommentViewWidgetController>(
              tag: noticeId,
              builder: (controller){
                return Column(
                  children: controller.showingController.comments.map((comment) =>
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.w),
                          child: CommentWidget(
                              comment: comment,
                              commentController: controller.showingController
                          )
                      )
                  ).toList(),
                );
              }
          ),
          //#. 댓글 불러오기
          GetBuilder<CommentViewWidgetController>(
              tag: noticeId,
              builder: (controller){
                if(controller.showingController.loadingState == LoadingState.success){
                  return TextButton(
                      onPressed: (){
                        controller.loadComment();
                      },
                      child: const Text('더보기')
                  );
                }
                else if(controller.showingController.loadingState == LoadingState.noMoreData){
                  return const Text("마지막 댓글 입니다.");
                }
                else if(controller.showingController.loadingState == LoadingState.loading){
                  return const CupertinoActivityIndicator();
                }
                else{
                  return const Text("댓글을 불러 올 수 없습니다.");
                }
              }
          ),
        ],
      ),
    );
  }
}
