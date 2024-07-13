import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/CommentService.dart';
import 'package:homerun/Common/Comment/Enums.dart';
import 'package:homerun/Common/Comment/CommentReferences.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';

class ReplyCommentWidgetController extends GetxController{
  final String noticeId;
  late final CollectionReference replyCollection;
  List<Comment> replyList = [];
  LoadingState loadingState = LoadingState.before;
  final Comment replyTarget;
  static const int commentsPerLoad = 1;

  ReplyCommentWidgetController({required this.noticeId , required this.replyTarget}){
    replyCollection = CommentReferences.getReplyCollection(replyTarget.documentSnapshot.reference);
  }

  static String makeTag(String noticeId, String targetCommentId) => "$noticeId/$targetCommentId";

  Future<Result> load({bool reset = false}) async {
    loadingState = LoadingState.loading;
    update();


    if(reset){
      replyList = [];
    }

    Result<List<Comment>> result = await CommentService.instance.getComments(
      commentCollection: replyCollection,
      orderBy: OrderType.date,
      descending: false,
      index: commentsPerLoad,
      startAfter: replyList.isNotEmpty ? replyList.last : null
    );


    if(result.isSuccess){
      replyList.addAll(result.content!);
      if(result.content!.length != commentsPerLoad){
        loadingState = LoadingState.noMoreData;
      }
      else{
        loadingState = LoadingState.success;
      }
    }
    else{
      StaticLogger.logger.e('[ReplyCommentWidgetController.load()] ${result.exception}');
      loadingState = LoadingState.fail;
    }
    update();
    return result;
  }

  Future<Result<Comment>> upload(String content) async {
    Result<Comment> result = await CommentService.instance.upload(
      commentCollection: replyCollection,
      content: content,
      replyTarget: replyTarget.documentSnapshot.reference,
      hasLikes: true,
    );

    if(result.isSuccess){
      replyList.add(result.content!);
      update();
    }

    return result;
  }

  Future<Result<void>> delete(Comment comment)async {
    Result<void> result = await CommentService.instance.delete(comment);

    if(result.isSuccess){
      replyList.remove(comment);
      update();
    }

    return result;
  }

  Future<Result<void>> updateComment(Comment comment , String content)async {
    Result<void> result = await CommentService.instance.update(comment.documentSnapshot.reference , content);

    if(result.isSuccess){
      replyList.remove(comment);
      update();
    }

    return result;
  }

}