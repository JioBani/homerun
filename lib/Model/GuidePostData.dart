import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';

class GuidePostData{
  final String title;
  final String subTitle;
  final String thumbnailImagePath;
  final String postPdfPath;
  final String category;
  DateTime? updateAt;
  final bool isNone;
  final Object? exception;

  GuidePostData({
    required this.category,
    required this.title,
    required this.subTitle,
    required this.thumbnailImagePath,
    required this.postPdfPath,
    required this.updateAt,
    this.isNone = false,
    this.exception
  });

  factory GuidePostData.fromMap(Map<String, dynamic> map) {
    Timestamp? updateAt = map['updateAt'] as Timestamp;
    return GuidePostData(
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      thumbnailImagePath: map['thumbnailImagePath'] ?? '',
      postPdfPath: map['postPdfPath'] ?? '',
      updateAt: updateAt.toDate()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'title': title,
      'subTitle': subTitle,
      'thumbnailImagePath': thumbnailImagePath,
      'postPdfPath': postPdfPath,
      'updateAt': updateAt != null ? Timestamp.fromDate(updateAt!) : null,
    };
  }

  static GuidePostData fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      StaticLogger.logger.e("[GuidePostData.fromDocumentSnapshot()] 데이터를 변환하지 못 했습니다.");
      throw Exception("데이터 없음");
    }

    Timestamp? updateAt = data['updateAt'] as Timestamp;

    return GuidePostData(
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      subTitle: data['subTitle'] ?? '',
      thumbnailImagePath: data['thumbnailImagePath'] ?? '',
      postPdfPath: data['postPdfPath'] ?? '',
      updateAt: updateAt.toDate(),
    );
  }

  factory GuidePostData.none() {
    return GuidePostData(
        category: '',
        title: '',
        subTitle: '',
        thumbnailImagePath: '',
        postPdfPath: '',
        updateAt: null,
        isNone: true
    );
  }

  factory GuidePostData.error(Object exception) {
    return GuidePostData(
        category: '',
        title: '',
        subTitle: '',
        thumbnailImagePath: '',
        postPdfPath: '',
        updateAt: null,
        exception: exception
    );
  }
}