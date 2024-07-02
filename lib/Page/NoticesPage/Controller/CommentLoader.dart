import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/Common/FirebaseResponse.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
import 'package:homerun/Page/NoticesPage/Model/CommentDto.dart';
import 'package:homerun/Page/NoticesPage/Service/CommentService.dart';

import 'CommentViewWidgetController.dart';

class CommentLoader{
  CommentViewWidgetController controller;
  List<Comment> comments = [];
  LoadingState loadingState = LoadingState.before;
  List<DocumentSnapshot> commentSnapshotList = [];
  CommentService commentService = CommentService.instance;
  String noticeId;

  CommentLoader({
    required this.controller,
    required this.noticeId,
  });

  Future<void> getNextComments(int index , {bool reset = false}) async{

    if(reset){
      commentSnapshotList = [];
      comments = [];
    }

    Result<List<Comment>> result;

    if(comments.isEmpty){
      result = await commentService.getComments(
        noticeId: noticeId,
        orderBy: SortOrder.latest,
        type:  CommentType.free,
        index: index,
      );
    }
    else{
      result = await commentService.getComments(
        noticeId: noticeId,
        orderBy: SortOrder.latest,
        type:  CommentType.free,
        index: index,
        startAfter: comments.last.snapshot
      );
    }

    if(!result.isSuccess){
      loadingState = LoadingState.fail;
      controller.update();
      return;
    }

    if(result.content!.isEmpty){
      loadingState = LoadingState.noMoreData;
      controller.update();
      return;
    }

    try{
      comments.addAll(result.content!);
      loadingState = LoadingState.success;
      controller.update();
      return;
    }catch(e,s){
      StaticLogger.logger.e('[CommentLoader.getNextComments()] $e\n$s');
      loadingState = LoadingState.fail;
      controller.update();
      return;
    }

  }
}