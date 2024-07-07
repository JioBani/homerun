import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDto {
  final String content;
  final String uid;
  final Timestamp date;
  final DocumentReference? replyTarget;
  final int? like;
  final int? dislike;


  CommentDto({
    required this.content,
    required this.uid,
    required this.date,
    this.replyTarget,
    this.like,
    this.dislike,
  });

  factory CommentDto.fromMap(Map<String, dynamic> map) {
    return CommentDto(
        date: map['date'],
        like: map['like'],
        replyTarget: map['replyTarget'],
        dislike: map['dislike'],
        content: map['content'],
        uid: map['uid']
    );
  }

  factory CommentDto.error() {
    return CommentDto(
        date: Timestamp.now(),
        like: null,
        dislike: null,
        content: '',
        uid: ''
    );
  }

  CommentDto.test()
      : date = Timestamp.now(),
        like = 0,
        dislike = 0,
        replyTarget = null,
        content = '청년특공 어떻게 될까요? 부모님과 함께 살고 있는데도 가능할까요? 부린이라 모르는게 너무 많아요....ㅠ_ㅠ',
        uid = 'test';

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'uid' : uid,
      'date': date,
      'like': like,
      'dislike': dislike,
      'replyTarget' : replyTarget,
    };
  }
}
