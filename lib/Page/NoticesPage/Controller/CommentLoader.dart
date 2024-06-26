import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/Common/FirebaseResponse.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';

import 'CommentViewWidgetController.dart';

class CommentLoader{
  CommentViewWidgetController controller;
  List<Comment> comments = [];
  LoadingState loadingState = LoadingState.before;
  Query query;

  CommentLoader({
    required this.controller,
    required this.query
  });

  Future<void> load() async {
    loadingState = LoadingState.loading;

    FirebaseResponse<QuerySnapshot> response = await FirebaseResponse.handleRequest<QuerySnapshot>(
        action: () => query.get()
    );

    if(response.isSuccess){
      comments = (response.response!.docs.map((e) =>  Comment.fromMap(e.data() as Map<String , dynamic> , e.id))).toList();
      StaticLogger.logger.i('[CommentViewWidgetController.loadComments()] 댓글 가져오기 성공 :${response.exception} ${response.response!.docs.length}');
      loadingState = LoadingState.success;
      controller.update();
    }
    else{
      StaticLogger.logger.e('[CommentViewWidgetController.loadComments()] 댓글 가져오기 실패 :${response.exception}');
      loadingState = LoadingState.fail;
      controller.update();
    }
  }

}