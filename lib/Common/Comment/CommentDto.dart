import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDto {
  String content;
  final String uid;
  Timestamp date;
  final DocumentReference? replyTarget;
  int? likes;
  int? dislikes;

  CommentDto({
    required this.content,
    required this.uid,
    required this.date,
    this.replyTarget,
    this.likes,
    this.dislikes,
  });

  factory CommentDto.fromMap(Map<String, dynamic> map) {
    return CommentDto(
      date: map[CommentFields.date],
      likes: map[CommentFields.likes],
      replyTarget: map[CommentFields.replyTarget],
      dislikes: map[CommentFields.dislikes],
      content: map[CommentFields.content],
      uid: map[CommentFields.uid],
    );
  }

  factory CommentDto.error() {
    return CommentDto(
      date: Timestamp.now(),
      likes: null,
      dislikes: null,
      content: '',
      uid: '',
    );
  }

  CommentDto.test()
      : date = Timestamp.now(),
        likes = 0,
        dislikes = 0,
        replyTarget = null,
        content = '청년특공 어떻게 될까요? 부모님과 함께 살고 있는데도 가능할까요? 부린이라 모르는게 너무 많아요....ㅠ_ㅠ',
        uid = 'test';

  Map<String, dynamic> toMap() {
    return {
      CommentFields.content: content,
      CommentFields.uid: uid,
      CommentFields.date: date,
      CommentFields.likes: likes,
      CommentFields.dislikes: dislikes,
      CommentFields.replyTarget: replyTarget,
    };
  }
}


extension CommentFields on CommentDto {
  static const String content = 'content';
  static const String uid = 'uid';
  static const String date = 'date';
  static const String likes = 'likes';
  static const String dislikes = 'dislikes';
  static const String replyTarget = 'replyTarget';
}

