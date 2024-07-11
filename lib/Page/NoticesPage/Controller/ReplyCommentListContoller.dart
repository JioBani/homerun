import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/CommentService.dart';
import 'package:homerun/Common/Comment/Enums.dart';
import 'package:homerun/Common/Firebase/FirestoreReferences.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';

class ReplyCommentWidgetController extends GetxController{
  final String noticeId;
  late final CollectionReference replyCollection;
  List<Comment> replyList = [];
  LoadingState loadingState = LoadingState.before;
  final Comment replyTarget;

  ReplyCommentWidgetController({required this.noticeId , required this.replyTarget}){
    replyCollection = FirestoreReferences.getReplyCollection(replyTarget.documentSnapshot.reference);
  }

  static String makeTag(String noticeId, String targetCommentId) => "$noticeId/$targetCommentId";

  Future<void> load() async {
    loadingState = LoadingState.loading;
    update();
    Result<List<Comment>> result = await CommentService.instance.getComments(
      commentCollection: replyCollection,
      orderBy: OrderType.date,
      descending: false
    );


    if(result.isSuccess){
      replyList = result.content!;
      loadingState = LoadingState.success;
    }
    else{
      StaticLogger.logger.e('[ReplyCommentWidgetController.load()] ${result.exception}');
      loadingState = LoadingState.fail;
    }
    update();
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
}