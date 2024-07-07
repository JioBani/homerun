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
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  late final CollectionReference collectionReference;

  ReplyCommentWidgetController({required this.noticeId , required DocumentReference replyRef}){
    replyCollection = FirestoreReferences.getReplyCollection(replyRef);
  }

  static String makeTag(String noticeId, String targetCommentId) => "$noticeId/$targetCommentId";

  Future<void> load() async {

    Result<List<Comment>> result = await CommentService.instance.getComments(
      commentCollection: replyCollection,
      orderBy: OrderType.date,
    );


    if(result.isSuccess){
      replyList = result.content!;
      loadingState.value = LoadingState.success;
    }
    else{
      StaticLogger.logger.e('[ReplyCommentWidgetController.load()] ${result.exception}');
      loadingState.value = LoadingState.fail;
    }
  }
}