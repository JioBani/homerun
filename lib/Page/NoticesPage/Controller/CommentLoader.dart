import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/Common/FirebaseResponse.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
import 'package:homerun/Page/NoticesPage/Model/CommentDto.dart';

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
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      comments = await Future.wait(response.response!.docs.map((e) => getComment(e , uid)));

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

  Future<Comment> getComment(DocumentSnapshot doc, String? uid) async {
    try{
      int likeState;

      if(uid != null){
        DocumentSnapshot likeDoc = await doc.reference.collection('likes').doc(uid).get();

        if(likeDoc.exists){
          likeState = likeDoc['value'] as int;
        }
        else{
          likeState = 0;
        }
      }
      else{
        likeState = 0;
      }

      CommentDto commentDto = CommentDto.fromMap(doc.data() as Map<String, dynamic>);

      return Comment(
          commentId: doc.id,
          commentDto: commentDto,
          likeState: likeState
      );
    }
    catch(e){
      StaticLogger.logger.e('[CommentLoader.getComment()] ${doc.id} : $e');
      return Comment(
          commentId: doc.id,
          commentDto: CommentDto.fromMap(doc.data() as Map<String, dynamic>),
          likeState: 0
      );
    }
  }

}