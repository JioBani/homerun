import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Controller/CommentListController.dart';
import 'package:homerun/Common/Comment/Model/Comment.dart';
import 'package:homerun/Common/Comment/Service/CommentService.dart';
import 'package:homerun/Common/Comment/Model/Enums.dart';
import 'package:homerun/Common/Comment/Model/LikeState.dart';
import 'package:homerun/Common/Comment/CommentReferences.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';

class CommentViewWidgetController extends GetxController {
  static const int initCommentNum = 2;
  static const int loadCommentNum = 3;

  late final Map<NoticeCommentType, Map<OrderType, CommentListController>> commentListControllers;

  final String noticeId;
  final TabController tabController;
  late OrderType orderType;
  late NoticeCommentType noticeCommentType;
  late CommentListController showingController;

  CommentViewWidgetController({
    required this.noticeId,
    required this.tabController,
  }) {
    commentListControllers = {
      NoticeCommentType.free: {
        OrderType.date: createCommentListController(NoticeCommentType.free, OrderType.date),
        OrderType.likes: createCommentListController(NoticeCommentType.free, OrderType.likes),
      },
      NoticeCommentType.eligibility: {
        OrderType.date: createCommentListController(NoticeCommentType.eligibility, OrderType.date),
        OrderType.likes: createCommentListController(NoticeCommentType.eligibility, OrderType.likes),
      },
    };

    noticeCommentType = NoticeCommentType.eligibility;
    orderType = OrderType.likes;
    showingController = commentListControllers[noticeCommentType]![orderType]!;

    loadComment(reset: true);
  }

  @override
  void onInit() {
    tabController.addListener(onPageChange);
    super.onInit();
  }

  @override
  void dispose() {
    tabController.removeListener(onPageChange);
    super.dispose();
  }

  CommentListController createCommentListController(NoticeCommentType type, OrderType order) {
    return CommentListController(
      commentCollection: CommentReferences.getNoticeComment(noticeId, type.name),
      orderType: order,
      hasLikes: true,
      hasReply: true,
      onUpdate: update,
    );
  }

  void onPageChange() {
    if (tabController.indexIsChanging) {
      noticeCommentType = tabController.index == 0 ? NoticeCommentType.eligibility : NoticeCommentType.free;
      showingController = commentListControllers[noticeCommentType]![orderType]!;

      if (showingController.loadingState == LoadingState.before) {
        loadComment();
      }
      update();
    }
  }

  void setOrderType(OrderType? newOrderType) {
    if (newOrderType != null && newOrderType != OrderType.none) {
      orderType = newOrderType;
      showingController = commentListControllers[noticeCommentType]![orderType]!;

      if (showingController.loadingState == LoadingState.before) {
        loadComment();
      }
      update();
    }
  }

  Future<Result?> loadComment({bool reset = false}) {
    return showingController.load(showingController.comments.isEmpty ? initCommentNum : loadCommentNum, reset: reset);
  }

  Future<Result<LikeState>> updateLikeState(Comment comment, int newLikeValue) {
    return CommentService.instance.updateLikeState(comment, newLikeValue);
  }
}
