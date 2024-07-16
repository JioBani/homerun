import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Model/Enums.dart';
import 'package:homerun/Common/Comment/CommentReferences.dart';
import 'package:homerun/Common/Comment/Controller/CommentListController.dart';

class CommentViewWidgetController extends GetxController{
  final String noticeId;
  final String reviewId;
  final int commentNum = 3;
  static const commentPerLoad = 3;
  bool isUploading = false;
  late final CommentListController commentListController;

  static makeTag(String noticeId, String reviewId){
    return "$noticeId:$reviewId";
  }

  CommentViewWidgetController({required this.noticeId , required this.reviewId}){
    commentListController = CommentListController(
        commentCollection: CommentReferences.getSiteReviewComment(noticeId, reviewId),
        orderType: OrderType.date,
        hasReply: true,
        hasLikes: true,
        onUpdate: update
    );
  }

  @override
  onInit(){
    super.onInit();
    commentListController.load(commentNum);
  }
}

class CommentUploadException implements Exception {
  final String message;

  CommentUploadException(this.message);

  @override
  String toString() {
    return "CommentUploadException: $message";
  }
}

class DuplicateCommentException extends CommentUploadException{
  DuplicateCommentException() : super("댓글 작성을 중복해서 시도하였습니다.");

  @override
  String toString() {
    return "DuplicateCommentException: $message";
  }
}