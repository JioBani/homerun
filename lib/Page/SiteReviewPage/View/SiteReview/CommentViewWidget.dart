import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/CommentDto.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class CommentViewWidget extends StatelessWidget {
  const CommentViewWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  Widget build(BuildContext context) {
    Get.put(
      CommentViewWidgetController(noticeId: siteReview.noticeId, reviewId: siteReview.id),
      tag: CommentViewWidgetController.makeTag(siteReview.noticeId, siteReview.id)
    );

    return GetBuilder<CommentViewWidgetController>(
        tag: CommentViewWidgetController.makeTag(siteReview.noticeId, siteReview.id),
        builder: (controller){
          if(controller.loadingState == LoadingState.success){
            return Column(
              children: controller.comments.map((comment) =>
                  CommentWidget(comment: comment , siteReview: siteReview,)
              ).toList(),
            );
          }
          else{
            return const SizedBox();
          }
        }
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.comment, required this.siteReview});
  final Comment comment;
  final SiteReview siteReview;

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<CommentViewWidgetController>(
        tag: CommentViewWidgetController.makeTag(siteReview.noticeId, siteReview.id)
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 30.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.w),
              child: Image.asset(
                TestImages.irelia_6,
                width: 30.w,
                height: 30.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "내집은언제",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Palette.brightMode.mediumText,
                          fontSize: 14.sp
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Text(
                      TimeFormatter.formatTimeDifference(comment.commentDto.date.toDate()),
                      style: TextStyle(
                          color: Palette.brightMode.mediumText,
                          fontSize: 12.sp
                      ),
                    ),
                    const Spacer(),
                    Builder(builder: (context){
                      if(Get.find<AuthService>().tryGetUser()?.uid == comment.commentDto.uid){
                        return TextButton(
                            onPressed: (){
                              controller.removeComment(comment);
                              //controller.doUpdate();
                            },
                            child: const Text("삭제")
                        );
                      }
                      else{
                        return const SizedBox();
                      }
                    })
                  ],
                ),
                Text(
                  comment.commentDto.content,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Palette.brightMode.darkText
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

