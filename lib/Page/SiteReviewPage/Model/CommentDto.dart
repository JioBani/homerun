import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDto {
  final Timestamp date;
  final String content;
  final String uid;
  final String noticeId;
  final String reviewId;

  CommentDto({
    required this.date,
    required this.content,
    required this.uid,
    required this.noticeId,
    required this.reviewId,
  });

  factory CommentDto.fromMap(Map<String, dynamic> map) {
    return CommentDto(
        date: map['date'],
        content: map['content'],
        uid: map['uid'],
        noticeId: map['noticeId'],
        reviewId: map['reviewId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'content': content,
      'uid' : uid
    };
  }

  CommentDto.test() :
        date = Timestamp.now(),
        content = '청년특공 어떻게 될까요? 부모님과 함께 살고 있는데도 가능할까요? 부린이라 모르는게 너무 많아요....ㅠ_ㅠ',
        uid = 'test',
        noticeId = 'test',
        reviewId = 'test';
}
