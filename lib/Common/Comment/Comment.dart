import 'package:cloud_firestore/cloud_firestore.dart';

import 'CommentDto.dart';

class Comment {
  final String id;
  final CommentDto commentDto;
  final int? likeState;

  Comment({
    required this.id,
    required this.commentDto,
    required this.likeState,
  });

  factory Comment.fromMap(
      String id ,
      Map<String, dynamic> map,
      int likeState,
      DocumentSnapshot snapshot,
      ) {
    return Comment(
        id: id,
        commentDto: CommentDto.fromMap(map),
        likeState: likeState,
    );
  }

  factory Comment.error(){
    return Comment(
      id: 'error',
      commentDto: CommentDto.error(),
      likeState: null,
    );
  }

  Comment.test()
      : id = 'test',
        commentDto = CommentDto.test(),
        likeState = 0;



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
