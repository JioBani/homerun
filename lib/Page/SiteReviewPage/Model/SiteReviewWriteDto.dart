import 'package:cloud_firestore/cloud_firestore.dart';

class SiteReviewWriteDto{
  final String noticeId;
  final String title;
  final String content;
  final String thumbnail;
  final Timestamp date;

  SiteReviewWriteDto({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.thumbnail,
    required this.date,
  });

  Map<String, dynamic> toMap(){
    return {
      'noticeId' : noticeId,
      'title' : title,
      'content' : content,
      'thumbnail' : thumbnail,
      'date' : date,
    };
  }

  factory SiteReviewWriteDto.fromWrite({
    required String noticeId,
    required String title,
    required String content,
    required String thumbnail,
    required Timestamp date,
  }){

    return SiteReviewWriteDto(
      noticeId : noticeId,
      title : title,
      content : content,
      thumbnail : thumbnail,
      date : date,
    );
  }
}