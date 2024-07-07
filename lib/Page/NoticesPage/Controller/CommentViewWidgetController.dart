import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/CommentService.dart';
import 'package:homerun/Common/Comment/Enums.dart';
import 'package:homerun/Common/Comment/LikeState.dart';
import 'package:homerun/Common/Firebase/FirestoreReferences.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';

import 'CommentLoader.dart';

class CommentViewWidgetController extends GetxController{
  static const int initCommentNum = 2;
  static const int loadCommentNum = 3;

  late final Map<NoticeCommentType , Map<OrderType , CommentLoader>> commentLoaders;


  final String noticeId;
  Comment? replyTarget;

  
  //#1. 인기순
  //#2. 최신순

  CommentViewWidgetController({required this.noticeId}){
    commentLoaders = {
      NoticeCommentType.free : {
        //#. 자유 - 최신
        OrderType.date : CommentLoader(
            controller: this,
            noticeId: noticeId,
            commentType: NoticeCommentType.free,
            orderType: OrderType.date
        ),

        //#. 자유 - 인기
        OrderType.likes : CommentLoader(
            controller: this,
            noticeId: noticeId,
            commentType: NoticeCommentType.free,
            orderType: OrderType.likes
        ),
      },

      NoticeCommentType.eligibility : {
        //#. 자격 - 최신
        OrderType.date : CommentLoader(
            controller: this,
            noticeId: noticeId,
            commentType: NoticeCommentType.eligibility,
            orderType: OrderType.date
        ),

        //#. 자격 - 인기
        OrderType.likes : CommentLoader(
            controller: this,
            noticeId: noticeId,
            commentType: NoticeCommentType.eligibility,
            orderType: OrderType.likes
        ),
      }
    };
  }

  Future<void> uploadComment(String content) async {
    if(replyTarget == null){
      await CommentService.instance.upload(
        commentCollection: FirestoreReferences.getNoticeComment(noticeId, NoticeCommentType.free.name),
        content: content,
        hasLikes: true,
      );
    }
    else{
      await CommentService.instance.upload(
        commentCollection: replyTarget!.documentSnapshot.reference.collection('reply'),
        content: content,
        hasLikes: true,
        replyTarget: replyTarget!.documentSnapshot.reference
      );
    }

    reload();
  }

  Future<Result<void>> deleteComment(Comment comment)async {
    Result<void> result = await CommentService.instance.delete(comment);
    await reload();
    return result;
  }

  void setReplyMode(Comment? comment){
    replyTarget = comment;
    StaticLogger.logger.i('set reply : $comment');
  }

  Future<Result<List<Comment>>> loadComment(NoticeCommentType commentType, OrderType orderType){
    if(orderType == OrderType.none){
      throw Exception('OrderType이 올바르지 않습니다.');
    }
    return commentLoaders[commentType]![orderType]!.getComments(initCommentNum);
  }

  CommentLoader getCommentLoader(NoticeCommentType commentType, OrderType orderType){
    if(orderType == OrderType.none){
      throw Exception('OrderType이 올바르지 않습니다.');
    }
    return commentLoaders[commentType]![orderType]!;
  }

  Future<Result<LikeState>> updateLikeState(Comment comment , int newLikeValue){
    return CommentService.instance.updateLikeStatus(comment, newLikeValue);
  }

  Future<void> reload(){
    return Future.wait([
      commentLoaders[NoticeCommentType.free]![OrderType.date]!.reload(),
      commentLoaders[NoticeCommentType.free]![OrderType.likes]!.reload(),
      commentLoaders[NoticeCommentType.eligibility]![OrderType.date]!.reload(),
      commentLoaders[NoticeCommentType.eligibility]![OrderType.likes]!.reload(),
    ]);
  }

}