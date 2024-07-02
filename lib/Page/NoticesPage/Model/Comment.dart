import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Page/NoticesPage/Model/CommentDto.dart';

class Comment {
  final String commentId;
  final CommentDto commentDto;
  final int likeState;
  final DocumentSnapshot? snapshot;

  Comment({
    required this.commentId,
    required this.commentDto,
    required this.likeState,
    required this.snapshot
  });

  factory Comment.fromMap(
      String commentId ,
      Map<String, dynamic> map,
      int likeState,
      DocumentSnapshot snapshot,
    ) {
    return Comment(
        commentId: commentId,
        commentDto: CommentDto.fromMap(map),
        likeState: likeState,
        snapshot : snapshot
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'commentDto': commentDto.toMap(),
      'likeState': likeState,
      'snapshot' : snapshot.toString()
    };
  }

  Comment.test()
      : commentId = 'test',
        commentDto = CommentDto.test(),
        likeState = 0,
        snapshot = null;

}
