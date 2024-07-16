import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Model/Comment.dart';
import 'package:homerun/Common/Comment/Service/CommentService.dart';
import 'package:homerun/Common/Comment/Model/Enums.dart';
import 'package:homerun/Common/Comment/CommentReferences.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';

class CommentListViewPageController extends GetxController{
  final String noticeId;
  final Comment replyTarget;
  late final CollectionReference collectionReference;
  List<Comment> comments = [];
  LoadingState loadingState = LoadingState.before;

  CommentListViewPageController({required this.noticeId, required this.replyTarget}){
    collectionReference = CommentReferences.getReplyCollection(replyTarget.documentSnapshot.reference);
  }

  static makeTag({required String noticeId, required String replyTargetId}){
    return "$noticeId:$replyTargetId";
  }

  Future<void> loadComment() async {
    loadingState = LoadingState.loading;
    update();

    Result<List<Comment>> result = await CommentService.instance.getComments(
      commentCollection: collectionReference,
      orderBy: OrderType.date,
      descending: false
    );

    if(result.isSuccess){
      comments.addAll(result.content!);
      loadingState = LoadingState.success;
    }
    else{
      loadingState = LoadingState.fail;
    }
    update();
  }

  Future<Result<Comment>> uploadComment(String content) async {
    Result<Comment> result = await CommentService.instance.upload(
      commentCollection: collectionReference,
      content: content,
      replyTarget: replyTarget.documentSnapshot.reference
    );

    if(result.isSuccess){
      comments.add(result.content!);
      update();
    }

    return result;
  }

  Future<Result<void>> deleteComment(Comment comment) async {
    Result<void> result = await CommentService.instance.delete(comment);

    if(result.isSuccess){
      if(comments.remove(comment)){
        update();
      }
    }

    return result;
  }
}