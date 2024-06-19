import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String displayName;
  final Timestamp date;
  final int good;
  final int bad;
  final String content;
  final String uid;

  Comment({
    required this.displayName,
    required this.date,
    required this.good,
    required this.bad,
    required this.content,
    required this.uid
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      displayName: map['displayName'],
      date: map['date'],
      good: map['good'],
      bad: map['bad'],
      content: map['content'],
      uid: map['uid']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'date': date,
      'good': good,
      'bad': bad,
      'content': content,
      'uid' : uid
    };
  }

  Comment.test()
      : displayName = 'Test User',
        date = Timestamp.now(),
        good = 0,
        bad = 0,
        content = '청년특공 어떻게 될까요? 부모님과 함께 살고 있는데도 가능할까요? 부린이라 모르는게 너무 많아요....ㅠ_ㅠ',
        uid = 'test';

}
