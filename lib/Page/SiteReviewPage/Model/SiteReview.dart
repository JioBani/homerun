import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Service/FirebaseStorageService.dart';

class SiteReview {
  String id;
  String noticeId;
  String title;
  String content;
  String writer;
  int view;
  String imagesRefPath;
  String thumbnailRefPath;


  SiteReview({
    required this.id,
    required this.noticeId,
    required this.title,
    required this.content,
    required this.writer,
    required this.view,
    required this.imagesRefPath,
    required this.thumbnailRefPath
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'noticeId' : noticeId,
      'title': title,
      'content': content,
      'writer': writer,
      'view': view,
      'imagesRefPath': imagesRefPath,
      'thumbnailRefPath': thumbnailRefPath,
    };
  }

  Map<String, dynamic> toUploadMap() {
    return {
      'noticeId' : noticeId,
      'title': title,
      'content': content,
      'writer': writer,
      'view': view,
      'imagesRefPath': imagesRefPath,
      'thumbnailRefPath': thumbnailRefPath,
    };
  }

  factory SiteReview.fromMap(Map<String, dynamic> map , String id) {
    try{
      return SiteReview(
        id : id,
        noticeId: map['noticeId'],
        title: map['title'],
        content: map['content'],
        writer: map['writer'],
        view: map['view'],
        imagesRefPath: map['imagesRefPath'],
        thumbnailRefPath: map['thumbnailRefPath'],
      );
    }catch(e , s){
      StaticLogger.logger.e("$e\n$s");
      return SiteReview.error();
    }
  }

  factory SiteReview.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return SiteReview.fromMap(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
  }

  factory SiteReview.fromWriteDto({
    required SiteReviewWriteDto writeDto,
    required String uid,
    required String docId,
  }) {

    String imageRefPath = FirebaseStorageService.getSiteImagePath(writeDto.noticeId , docId);
    String thumbnailRefPath = "$imageRefPath${writeDto.thumbnail}"; //imageRefPath가 /를 포함하고 있음

    return SiteReview(
      id : '',
      noticeId: writeDto.noticeId,
      title: writeDto.title,
      content: writeDto.content,
      writer: uid,
      view: 0,
      imagesRefPath: imageRefPath,
      thumbnailRefPath: thumbnailRefPath,
    );
  }

  factory SiteReview.test() {
    return SiteReview(
      id : "test",
      noticeId: '1',
      title: "테스트1",
      content: '테스트1',
      writer: 'writer',
      view: 0,
      imagesRefPath: 'site_review/test/1',
      thumbnailRefPath: 'site_review/test/1',
    );
  }

  factory SiteReview.error() {
    return SiteReview(
      id : "error",
      noticeId: 'error',
      title: "error",
      content: 'error',
      writer: 'error',
      view: 0,
      imagesRefPath: '',
      thumbnailRefPath: '',
    );
  }
}
