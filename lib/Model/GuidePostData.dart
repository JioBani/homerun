import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';

class GuidePostData{
  final String title;
  final String subTitle;
  final String thumbnailImagePath;
  final String postPdfPath;
  final String category;

  GuidePostData({
    required this.category,
    required this.title,
    required this.subTitle,
    required this.thumbnailImagePath,
    required this.postPdfPath,
  });

  factory GuidePostData.fromMap(Map<String, dynamic> map) {
    return GuidePostData(
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      thumbnailImagePath: map['thumbnailImagePath'] ?? '',
      postPdfPath: map['postPdfPath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'title': title,
      'subTitle': subTitle,
      'thumbnailImagePath': thumbnailImagePath,
      'postPdfPath': postPdfPath,
    };
  }

  static GuidePostData? fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      StaticLogger.logger.e("[GuidePostData.fromDocumentSnapshot()] 데이터를 변환하지 못 했습니다.");
      return null;
    }
    return GuidePostData(
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      subTitle: data['subTitle'] ?? '',
      thumbnailImagePath: data['thumbnailImagePath'] ?? '',
      postPdfPath: data['postPdfPath'] ?? '',
    );
  }
}