import 'package:homerun/Page/NoticesPage/Model/CommentDto.dart';

class Comment {
  final String commentId;
  final CommentDto commentDto;
  final int likeState;

  Comment({
    required this.commentId,
    required this.commentDto,
    required this.likeState
  });

  factory Comment.fromMap(
      String commentId ,
      Map<String, dynamic> map,
      int likeState
    ) {
    return Comment(
        commentId: commentId,
        commentDto: CommentDto.fromMap(map),
        likeState: likeState
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'commentDto': commentDto.toMap(),
      'likeState': likeState
    };
  }

  Comment.test()
      : commentId = 'test',
        commentDto = CommentDto.test(),
        likeState = 0;

}
