import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/CommentService.dart';
import 'package:homerun/Common/Firebase/FirestoreReferences.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Service/Auth/AuthService.dart';

class CommentViewWidgetController extends GetxController{
  final String noticeId;
  final String reviewId;
  LoadingState loadingState = LoadingState.before;
  List<Comment> comments = [];
  final int commentNum = 3;
  late final CollectionReference commentCollection ;
  bool isUploading = false;

  static makeTag(String noticeId, String reviewId){
    return "$noticeId:$reviewId";
  }

  CommentViewWidgetController({required this.noticeId , required this.reviewId}){
    commentCollection = FirestoreReferences.getSiteReviewComment(noticeId, reviewId);
  }

  @override
  onInit(){
    super.onInit();
    getNextComments();
  }

  Future<void> getNextComments() async {
    loadingState = LoadingState.loading;


    Result<List<Comment>> result = await CommentService.instance.getComments(
        commentCollection: commentCollection,
        index: commentNum,
        orderBy: OrderType.date,
        startAfter: comments.isEmpty ? null : comments.last
    );

    if(result.isSuccess){
      comments.addAll(result.content!);
      StaticLogger.logger.i('댓글 불러오기 성공');
      loadingState = LoadingState.success;
    }
    else{
      StaticLogger.logger.i('댓글 불러오기 실패');
      loadingState = LoadingState.fail;
    }

    update();
  }

  Future<Result<Comment>> upload(String content) async {
    if(isUploading){
      return Result.fromFailure(DuplicateCommentException(), StackTrace.current);
    }

    isUploading = true;

    Result<Comment> result = await CommentService.instance.upload(
      commentCollection: commentCollection,
      content: content
    );

    isUploading = false;
    update();

    return result;
  }

  Future<Result<void>> removeComment(Comment comment) async{
    Result<void> result = await CommentService.instance.remove(comment);

    if(result.isSuccess){
      comments.remove(comment);
      Get.snackbar("알림", "댓글을 삭제하였습니다.");
    }
    else{
      if(result.exception is ApplicationUnauthorizedException){
        Get.snackbar("오류", "로그인이 필요합니다.");
      }
      else{
        Get.snackbar("오류", "댓글 삭제에 실패하였습니다.");
      }
    }

    update();

    return result;
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