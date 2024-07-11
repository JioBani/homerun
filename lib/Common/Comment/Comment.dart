import 'package:cloud_firestore/cloud_firestore.dart';

import 'CommentDto.dart';

class Comment {
  final String id;
  final CommentDto commentDto;
  final int? likeState;
  final DocumentSnapshot documentSnapshot;
  final int replyCount;

  Comment({
    required this.id,
    required this.commentDto,
    required this.likeState,
    required this.documentSnapshot,
    required this.replyCount,
  });

  factory Comment.fromMap({
    required String id ,
    required Map<String, dynamic> map,
    required int likeState,
    required int replyCount,
    required DocumentSnapshot documentSnapshot,
  }){
    return Comment(
      id: id,
      commentDto: CommentDto.fromMap(map),
      likeState: likeState,
      replyCount : replyCount,
      documentSnapshot: documentSnapshot,
    );
  }

  factory Comment.error(DocumentSnapshot documentSnapshot){
    return Comment(
      id: 'error',
      commentDto: CommentDto.error(),
      likeState: null,
      replyCount: 0,
      documentSnapshot: documentSnapshot,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': id,
      'commentDto': commentDto.toMap(),
      'likeState': likeState,
      'replyCount' : replyCount,
      'documentSnapshot' : documentSnapshot
    };
  }

  bool isError(){
    return id == 'error';
  }
}
