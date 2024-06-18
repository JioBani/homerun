import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String displayName;
  Timestamp date;
  int good;
  int bad;
  String content;

  Comment({
    required this.displayName,
    required this.date,
    required this.good,
    required this.bad,
    required this.content,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      displayName: map['displayName'],
      date: map['date'],
      good: map['good'],
      bad: map['bad'],
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'date': date,
      'good': good,
      'bad': bad,
      'content': content,
    };
  }
}
