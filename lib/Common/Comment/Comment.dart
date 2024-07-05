import 'package:cloud_firestore/cloud_firestore.dart';

import 'CommentDto.dart';

class Comment {
  final String id;
  final CommentDto commentDto;
  final int? likeState;
  final DocumentSnapshot? documentSnapshot;

  Comment({
    required this.id,
    required this.commentDto,
    required this.likeState,
    required this.documentSnapshot,
  });

  factory Comment.fromMap(
      String id ,
      Map<String, dynamic> map,
      int likeState,
      DocumentSnapshot documentSnapshot,
      ) {
    return Comment(
      id: id,
      commentDto: CommentDto.fromMap(map),
      likeState: likeState,
      documentSnapshot: documentSnapshot
    );
  }

  factory Comment.error(){
    return Comment(
      id: 'error',
      commentDto: CommentDto.error(),
      likeState: null,
      documentSnapshot: null
    );
  }

  Comment.test()
      : id = 'test',
        commentDto = CommentDto.test(),
        likeState = 0,
        documentSnapshot = null;



  Map<String, dynamic> toMap() {
    return {
      'commentId': id,
      'commentDto': commentDto.toMap(),
      'likeState': likeState,
    };
  }

  bool isError(){
    return id == 'error';
  }
}
