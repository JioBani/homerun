import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/NoticesPage/Service/CommentService.dart';

import 'CommentLoader.dart';

class CommentViewWidgetController extends GetxController{
  final String noticeId;
  CommentService commentService = CommentService();

  Stream<QuerySnapshot>? snapshotStream;

  late final CommentLoader resendLoader;
  late final CommentLoader popularityLoader;

  
  //#1. 인기순
  //#2. 최신순

  CommentViewWidgetController({required this.noticeId}){
    resendLoader = CommentLoader(
        controller: this,
        query: FirebaseFirestore.instance
            .collection('notice_comment')
            .doc(noticeId)
            .collection('free')
            .orderBy('date' , descending: true)
    );

    popularityLoader = CommentLoader(
        controller: this,
        query: FirebaseFirestore.instance
            .collection('notice_comment')
            .doc(noticeId)
            .collection('free')
            .orderBy('like' , descending: true)
            .limit(3)
    );
  }

  Future<void> uploadComment(String content) async {
    await commentService.uploadComment(content, noticeId);
    resendLoader.load();
    popularityLoader.load();
  }

  Future<void> deleteComment(String commentId)async {
    await commentService.delete(noticeId , commentId);
    //TODO 적절하게 load하도록 변경
    resendLoader.load();
    popularityLoader.load();
  }

}