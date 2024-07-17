import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/View/CommentInputWidget.dart';
import 'package:homerun/Common/Comment/View/CommentWidget.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/CommentViewWidgetController.dart';

class CommentViewWidget extends StatelessWidget {
  const CommentViewWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(
        CommentViewWidgetController(noticeId: siteReview.noticeId, reviewId: siteReview.id),
        tag: CommentViewWidgetController.makeTag(siteReview.noticeId, siteReview.id)
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w),
          child: Text(
            "댓글",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black
            ),
          ),
        ),
        CommentInputWidget(
          onTapSubmit: (context , content , focusNode , textController) async {
            Result? result = await controller.commentListController.upload(content);
            if(result != null && result.isSuccess){
              focusNode.unfocus();
              textController.clear();
            }
          },
        ),
        SizedBox(height: 15.w,),
        GetBuilder<CommentViewWidgetController>(
          tag: CommentViewWidgetController.makeTag(siteReview.noticeId, siteReview.id),
          builder: (controller){
            return Column(
              children: controller.commentListController.comments.map((comment) =>
                  CommentWidget(
                    commentController: controller.commentListController,
                    comment: comment,
                  )
              ).toList(),
            );
          }
        ),
        GetBuilder<CommentViewWidgetController>(
            tag: CommentViewWidgetController.makeTag(siteReview.noticeId, siteReview.id),
            builder: (controller){
              if(
                controller.commentListController.loadingState == LoadingState.success
              ){
                return Center(
                  child: TextButton(
                      onPressed: (){
                        controller.commentListController.load(CommentViewWidgetController.commentPerLoad);
                      },
                      child: const Text("더보기")
                  ),
                );
              }
              else if(controller.commentListController.loadingState == LoadingState.noMoreData){
                return const SizedBox();
              }
              else if(controller.commentListController.loadingState == LoadingState.loading){
                return const Center(child: CupertinoActivityIndicator());
              }
              else{
                return const Center(child: Text("데이터를 불러 올 수 없습니다."));
              }
            }
        ),
      ],
    );
  }
}