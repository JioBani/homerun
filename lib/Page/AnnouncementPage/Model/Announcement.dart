import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Page/AnnouncementPage/Model/AnnouncementDto.dart';

class Announcement{
  final DocumentSnapshot documentSnapshot;
  final AnnouncementDto? announcementDto;

  /// 파싱에 실패한경우 true
  final bool hasError;
  final Object? error;
  final StackTrace? stackTrace;

  Announcement({
    required this.documentSnapshot,
    this.announcementDto,
    this.hasError = false,
    this.error,
    this.stackTrace,
  });

  factory Announcement.fromFailure({
    required DocumentSnapshot documentSnapshot,
    required Object error,
    required StackTrace stackTrace,
  }){
    return Announcement(
      announcementDto: null,
      documentSnapshot: documentSnapshot,
      hasError: true,
      error: error,
      stackTrace: stackTrace,
    );
  }

  factory Announcement.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    try{
      return Announcement(
        documentSnapshot: documentSnapshot,
        announcementDto: AnnouncementDto.fromDocumentSnapshot(documentSnapshot),
      );
    }catch(e,s){
      return Announcement.fromFailure(
          documentSnapshot: documentSnapshot,
          error: e,
          stackTrace: s
      );
    }
  }

  static List<Announcement> makeList(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) => Announcement.fromDocumentSnapshot(e)).toList();
  }
}