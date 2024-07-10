import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/CommentService.dart';
import 'package:homerun/Common/Comment/Enums.dart';
import 'package:homerun/Common/Firebase/FirestoreReferences.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';

import 'CommentViewWidgetController.dart';

class CommentLoader{
  final CommentViewWidgetController controller;
  final String noticeId;
  late final CollectionReference collection;
  final NoticeCommentType commentType;
  final OrderType orderType;
  int allCommentCount = 0;

  List<Comment> comments = [];
  LoadingState loadingState = LoadingState.before;

  CommentLoader({
    required this.controller,
    required this.noticeId,
    required this.commentType,
    required this.orderType,
  }){
    collection = FirestoreReferences.getNoticeComment(noticeId,commentType.name);
  }

  Future<Result<List<Comment>>> getComments(int index, {bool reset = false}) async {
    loadingState = LoadingState.loading;
    if(reset){
      comments = [];
      await getCommentCount();
    }

    Result<List<Comment>> result = await CommentService.instance.getComments(
        commentCollection: collection,
        orderBy: orderType,
        index: index,
        startAfter: comments.isNotEmpty ? comments.last : null,
    );

    if(!result.isSuccess){
      loadingState = LoadingState.fail;
      StaticLogger.logger.e(result.exception);
      controller.update();
      return result;
    }
    else{
      comments.addAll(result.content!);

      if(result.content!.length != index){
        loadingState = LoadingState.noMoreData;
      }
      else{
        loadingState = LoadingState.success;
      }
      controller.update();
      return result;
    }
  }

  Future<void> reload() async {
    if(comments.isNotEmpty){
      await getComments(comments.length , reset:true);
    }
  }

  Future<Result<int?>> getCommentCount() async {
    Result<int?> count = await CommentService.instance.getCommentCount(collection);
    if(count.isSuccess){
      allCommentCount = count.content ?? 0;
    }
    return count;
  }

  void addComment(Comment comment){
    comments.insert(0, comment);
    allCommentCount++;
  }

  void deleteComment(Comment comment){
    if(comments.remove(comment)){
      allCommentCount--;
    }
  }

}