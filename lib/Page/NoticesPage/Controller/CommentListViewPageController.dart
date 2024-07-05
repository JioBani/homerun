import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';

class CommentListViewPageController extends GetxController{
  final String noticeId;
  final String? replyTarget;
  Rx<LoadingState> loadingState = Rx(LoadingState.before);
  List<Comment> comments = [];

  CommentListViewPageController({required this.noticeId , required this.replyTarget});
}