import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/NoticesPage/Controller/ReplyCommentListContoller.dart';
import 'package:homerun/Page/NoticesPage/Service/CommentService.dart';

import 'CommentLoader.dart';

class CommentViewWidgetController extends GetxController{
  static const int initCommentNum = 3;
  static const int loadCommentNum = 5;


  final String noticeId;
  CommentService commentService = CommentService.instance;

  late final CommentLoader resendLoader;
  late final CommentLoader popularityLoader;

  String? replyTarget;

  
  //#1. 인기순
  //#2. 최신순

  CommentViewWidgetController({required this.noticeId}){
    resendLoader = CommentLoader(
        controller: this,
        noticeId: noticeId
    );

    popularityLoader = CommentLoader(
        controller: this,
        noticeId: noticeId
    );
  }

  Future<void> uploadComment(String content) async {
    if(replyTarget == null){
      await commentService.uploadComment(content, noticeId);
    }
    else{
      await commentService.uploadComment(content, noticeId ,replyTarget: replyTarget);
      try{
        var replyController = Get.find<ReplyCommentWidgetController>(
            tag: ReplyCommentWidgetController.makeTag(
                noticeId,
                replyTarget!
            )
        );

        replyController.load();
      }catch(e){

      }
    }

    resendLoader.getNextComments(initCommentNum , reset: true);
    popularityLoader.getNextComments(initCommentNum , reset: true);
  }

  Future<void> deleteComment(String commentId , String? replyTarget)async {
    await commentService.delete(noticeId , commentId , replyTarget: replyTarget);
    //TODO 적절하게 load하도록 변경
    resendLoader.getNextComments(initCommentNum , reset: true);
    popularityLoader.getNextComments(initCommentNum , reset: true);

    if(replyTarget != null){
      try{
        var replyController = Get.find<ReplyCommentWidgetController>(
            tag: ReplyCommentWidgetController.makeTag(
                noticeId,
                replyTarget
            )
        );

        replyController.load();
      }catch(e){

      }
    }

  }

  void setReplyMode(String? commentId){
    replyTarget = commentId;
    StaticLogger.logger.i('set reply : $commentId');
  }

}