import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/SiteReviewPage/Model/NoticeDto.dart';

class Notice{
  DocumentSnapshot documentSnapshot;
  NoticeDto? noticeDto;
  bool hasError;

  Notice({required this.documentSnapshot ,required this.noticeDto, required this.hasError});

  factory Notice.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    try{
      return Notice(
          documentSnapshot: documentSnapshot,
          noticeDto: NoticeDto.fromMap(documentSnapshot.data() as Map<String , dynamic>),
          hasError: false
      );
    }catch(e,s){
     StaticLogger.logger.e("$e\n$s");
     return Notice(
         documentSnapshot: documentSnapshot,
         noticeDto: null,
         hasError: true
     );
    }
  }
}