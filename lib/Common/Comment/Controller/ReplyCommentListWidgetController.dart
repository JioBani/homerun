import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Model/Comment.dart';
import 'package:homerun/Common/Comment/CommentReferences.dart';
import 'package:homerun/Common/Comment/Model/Enums.dart';

import '../Controller/CommentListController.dart';

class ReplyCommentListWidgetController extends GetxController{
  final Comment replyTarget;
  static const int commentsPerLoad = 5;
  late final CommentListController commentController;

  ReplyCommentListWidgetController({required this.replyTarget , required bool hasLikes}){
    commentController = CommentListController(
      commentCollection: CommentReferences.getReplyCollection(replyTarget.documentSnapshot.reference),
      orderType: OrderType.date,
      descending: false,
      hasReply: false,
      hasLikes: hasLikes,
      onUpdate: update
    );
  }
}