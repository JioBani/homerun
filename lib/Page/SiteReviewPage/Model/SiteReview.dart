import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReviewWriteDto.dart';
import 'package:homerun/Page/SiteReviewPage/SiteReviewReferences.dart';

import '../Value/SiteReviewFields.dart';

class SiteReview {
  String id;
  String noticeId;
  String title;
  String content;
  String writer;
  int view;
  String imagesRefPath;
  String thumbnailRefPath;
  Timestamp date;
  Timestamp? modified;

  SiteReview({
    required this.id,
    required this.noticeId,
    required this.title,
    required this.content,
    required this.writer,
    required this.view,
    required this.imagesRefPath,
    required this.thumbnailRefPath,
    required this.date,
    this.modified,
  });

  factory SiteReview.fromMap(Map<String, dynamic> map, String id) {
    try {
      return SiteReview(
        id: id,
        noticeId: map[SiteReviewFields.noticeId],
        title: map[SiteReviewFields.title],
        content: map[SiteReviewFields.content],
        writer: map[SiteReviewFields.writer],
        view: map[SiteReviewFields.view],
        imagesRefPath: map[SiteReviewFields.imagesRefPath],
        thumbnailRefPath: map[SiteReviewFields.thumbnailRefPath],
        date: map[SiteReviewFields.date],
        modified: map[SiteReviewFields.modified],
      );
    } catch (e, s) {
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
    String imageRefPath = SiteReviewReferences.getReviewImageFolderPath(writeDto.noticeId, docId);
    String thumbnailRefPath = SiteReviewReferences.getReviewThumbnailPath(writeDto.noticeId, docId, writeDto.thumbnail);

    return SiteReview(
      id: '',
      noticeId: writeDto.noticeId,
      title: writeDto.title,
      content: writeDto.content,
      writer: uid,
      view: 0,
      imagesRefPath: imageRefPath,
      thumbnailRefPath: thumbnailRefPath,
      date: writeDto.date,
    );
  }

  factory SiteReview.test() {
    return SiteReview(
      id: "test",
      noticeId: '1',
      title: "테스트1",
      content: '테스트1',
      writer: 'writer',
      view: 0,
      imagesRefPath: 'site_review/test/1',
      thumbnailRefPath: 'site_review/test/1',
      date: Timestamp.now(),
    );
  }

  factory SiteReview.error() {
    return SiteReview(
      id: "error",
      noticeId: 'error',
      title: "error",
      content: 'error',
      writer: 'error',
      view: 0,
      imagesRefPath: '',
      thumbnailRefPath: '',
      date: Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SiteReviewFields.id: id,
      SiteReviewFields.noticeId: noticeId,
      SiteReviewFields.title: title,
      SiteReviewFields.content: content,
      SiteReviewFields.writer: writer,
      SiteReviewFields.view: view,
      SiteReviewFields.imagesRefPath: imagesRefPath,
      SiteReviewFields.thumbnailRefPath: thumbnailRefPath,
      SiteReviewFields.date: date,
      SiteReviewFields.modified: modified,
    };
  }

  Map<String, dynamic> toUploadMap() {
    return {
      SiteReviewFields.noticeId: noticeId,
      SiteReviewFields.title: title,
      SiteReviewFields.content: content,
      SiteReviewFields.writer: writer,
      SiteReviewFields.view: view,
      SiteReviewFields.imagesRefPath: imagesRefPath,
      SiteReviewFields.thumbnailRefPath: thumbnailRefPath,
      SiteReviewFields.modified: modified,
    };
  }

  void replace(SiteReview replace) {
    id = replace.id;
    title = replace.title;
    content = replace.content;
    writer = replace.writer;
    view = replace.view;
    imagesRefPath = replace.imagesRefPath;
    thumbnailRefPath = replace.thumbnailRefPath;
    date = replace.date;
    modified = replace.modified;
  }
}
