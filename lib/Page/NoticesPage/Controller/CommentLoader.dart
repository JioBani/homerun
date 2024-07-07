import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/CommentService.dart';
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

}