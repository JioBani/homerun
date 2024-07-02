import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
import 'package:homerun/Page/NoticesPage/Service/CommentService.dart';

class ReplyCommentWidgetController extends GetxController{
  final String noticeId;
  final String targetCommentId;
  List<Comment> replyList = [];
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  static String makeTag(String noticeId, String targetCommentId) => "$noticeId/$targetCommentId";

  ReplyCommentWidgetController({required this.noticeId , required this.targetCommentId});

  Future<void> load() async {

    Result<List<Comment>> result = await CommentService.instance.getComments(
      noticeId: noticeId,
      orderBy: SortOrder.latest,
      type: CommentType.free,
      replyTarget: targetCommentId,
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