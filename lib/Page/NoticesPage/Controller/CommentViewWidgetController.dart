import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/CommentService.dart';
import 'package:homerun/Common/Comment/Enums.dart';
import 'package:homerun/Common/Comment/LikeState.dart';
import 'package:homerun/Common/Firebase/FirestoreReferences.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';

import 'CommentLoader.dart';

class CommentViewWidgetController extends GetxController{
  static const int initCommentNum = 2;
  static const int loadCommentNum = 3;

  late final Map<NoticeCommentType , Map<OrderType , CommentLoader>> commentLoaders;

  final String noticeId;
  final TabController tabController;
  late CommentLoader showLoader;

  Comment? replyTarget;

  
  //#1. 인기순
  //#2. 최신순

  CommentViewWidgetController({required this.noticeId, required this.tabController}){
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

    showLoader = commentLoaders[NoticeCommentType.eligibility]![OrderType.likes]!;
    loadComment(reset: true);
  }

  @override
  onInit(){
    tabController.addListener(onPageChange);
    super.onInit();
  }

  @override
  dispose(){
    tabController.removeListener(onPageChange);
    super.dispose();
  }

  void onPageChange(){
    if(tabController.indexIsChanging){
      if(tabController.index == 0){
        showLoader = commentLoaders[NoticeCommentType.eligibility]![OrderType.likes]!;
      }
      else{
        showLoader = commentLoaders[NoticeCommentType.free]![OrderType.likes]!;
      }

      if(showLoader.loadingState == LoadingState.before){
        loadComment();
      }
      update();
    }
  }

  Future<void> uploadComment(String content) async {
    if(replyTarget == null){
      await CommentService.instance.upload(
        commentCollection: FirestoreReferences.getNoticeComment(noticeId, showLoader.commentType.name),
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

  Future<Result<List<Comment>>> loadComment({bool reset = false}){
    if(reset){
      return showLoader.getComments(initCommentNum ,reset: reset);
    }
    else{
      if(showLoader.comments.isEmpty){
        return showLoader.getComments(initCommentNum);
      }
      else{
        return showLoader.getComments(loadCommentNum);
      }
    }
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