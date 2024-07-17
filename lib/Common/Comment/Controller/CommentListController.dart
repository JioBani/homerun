import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/Comment/Model/Comment.dart';
import 'package:homerun/Common/Comment/Service/CommentService.dart';
import 'package:homerun/Common/Comment/Model/Enums.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';

import '../View/CommentSnackBar.dart';

class CommentListController{
  late final CollectionReference commentCollection;
  List<Comment> comments = [];
  LoadingState loadingState = LoadingState.before;
  final OrderType orderType;
  final bool descending;
  final bool hasReply;
  final bool hasLikes;
  final Function? onUpdate;
  int allCommentCount = 0;

  CommentListController({
    required this.commentCollection,
    required this.orderType,
    this.descending = true,
    this.hasReply = true,
    this.hasLikes = true,
    this.onUpdate
  });

  static String makeTag(String noticeId, String targetCommentId) => "$noticeId/$targetCommentId";

  Future<Result> load(int nums, {bool reset = false}) async {
    loadingState = LoadingState.loading;
    onUpdate?.call();

    if(reset){
      comments = [];
      await getCommentCount();
    }


    Result<List<Comment>> result = await CommentService.instance.getComments(
        commentCollection: commentCollection,
        orderBy: orderType,
        descending: descending,
        index: nums,
        startAfter: comments.isNotEmpty ? comments.last : null,
        hasReply: hasReply
    );


    if(result.isSuccess){
      comments.addAll(result.content!);
      if(result.content!.length != nums){
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
    onUpdate?.call();
    return result;
  }

  Future<Result?> upload(String content , {Comment? replyTarget}) async {
    if(content.isEmpty){
      CommentSnackbar.show('알림', '내용을 입력해 주세요.');
      return null;
    }

    Result<Comment> result = await CommentService.instance.upload(
      commentCollection: commentCollection,
      content: content,
      replyTarget: replyTarget?.documentSnapshot.reference,
      hasLikes: hasLikes,
    );

    if(result.isSuccess){
      comments.add(result.content!);
      CommentSnackbar.show('알림', '댓글을 등록했습니다.');
      onUpdate?.call();
    }
    else{
      CommentSnackbar.show('오류', '댓글 등록에 실패했습니다.');
    }

    return result;
  }

  Future<void> delete(Comment comment)async {
    Result<void> result = await CommentService.instance.delete(comment);

    if(result.isSuccess){
      comments.remove(comment);
      CommentSnackbar.show('알림', '댓글을 삭제했습니다.');
      onUpdate?.call();
    }
    else{
      CommentSnackbar.show('오류', '댓글 삭제에 실패 했습니다.');
    }
  }

  Future<Result?> update(Comment comment , String content)async {
    if(content.isEmpty){
      CommentSnackbar.show('알림', '내용을 입력해 주세요.');
      return null;
    }

    Result<void> result = await CommentService.instance.update(comment.documentSnapshot.reference , content);

    if(result.isSuccess){
      comment.commentDto.content = content;
      CommentSnackbar.show('알림', '댓글을 수정했습니다.');
      onUpdate?.call();
    }
    else{
      CommentSnackbar.show('오류', '댓글 수정에 실패했습니다.');
    }

    return result;
  }

  Future<Result<int?>> getCommentCount() async {
    Result<int?> count = await CommentService.instance.getCommentCount(commentCollection);
    if(count.isSuccess){
      allCommentCount = count.content ?? 0;
    }
    return count;
  }
}