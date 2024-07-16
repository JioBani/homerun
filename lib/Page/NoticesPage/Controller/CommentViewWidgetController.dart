import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Model/Comment.dart';
import 'package:homerun/Common/Comment/Service/CommentService.dart';
import 'package:homerun/Common/Comment/Model/Enums.dart';
import 'package:homerun/Common/Comment/Model/LikeState.dart';
import 'package:homerun/Common/Comment/CommentReferences.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';

import 'CommentLoader.dart';

class CommentViewWidgetController extends GetxController{
  static const int initCommentNum = 2;
  static const int loadCommentNum = 3;

  late final Map<NoticeCommentType , Map<OrderType , CommentLoader>> commentLoaders;

  final String noticeId;
  final TabController tabController;
  late CommentLoader showLoader;
  late OrderType orderType;
  late NoticeCommentType noticeCommentType;

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

    orderType = OrderType.likes;
    noticeCommentType = NoticeCommentType.eligibility;

    showLoader = commentLoaders[noticeCommentType]![orderType]!;
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
        noticeCommentType = NoticeCommentType.eligibility;
      }
      else{
        noticeCommentType = NoticeCommentType.free;
      }

      showLoader = commentLoaders[noticeCommentType]![orderType]!;

      if(showLoader.loadingState == LoadingState.before){
        loadComment();
      }
      update();
    }
  }

  void setOrderType(OrderType? orderType){
    if(orderType != null && orderType != OrderType.none){
      this.orderType = orderType;
      showLoader = commentLoaders[noticeCommentType]![this.orderType]!;

      if(showLoader.loadingState == LoadingState.before){
        loadComment();
      }

      update();
    }
  }

  Future<Result<Comment>> uploadComment(String content) async {
    Result<Comment> result = await CommentService.instance.upload(
      commentCollection: CommentReferences.getNoticeComment(noticeId, showLoader.commentType.name),
      content: content,
      hasLikes: true,
    );

    if(result.isSuccess){
      showLoader.addComment(result.content!);
      update();
    }

    return result;
  }

  Future<Result<void>> deleteComment(Comment comment)async {
    Result<void> result = await CommentService.instance.delete(comment);

    if(result.isSuccess){
      showLoader.deleteComment(comment);
      update();
    }

    return result;
  }

  Future<Result<void>> updateComment(Comment comment , String content)async {
    Result<void> result = await CommentService.instance.update(comment.documentSnapshot.reference , content);

    if(result.isSuccess){
      comment.commentDto.content = content;
    }

    return result;
  }


  Future<Result<List<Comment>>> loadComment({bool reset = false}){
    if(showLoader.comments.isEmpty){
      return showLoader.getComments(initCommentNum , reset: reset);
    }
    else{
      return showLoader.getComments(loadCommentNum , reset: reset);
    }
  }

  Future<Result<LikeState>> updateLikeState(Comment comment , int newLikeValue){
    return CommentService.instance.updateLikeState(comment, newLikeValue);
  }

  Future<void> reload(){
    return showLoader.reload();
  }
}