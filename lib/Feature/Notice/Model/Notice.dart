import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Feature/Notice/Model/NoticeDto.dart';

class Notice{
  DocumentSnapshot documentSnapshot;
  NoticeDto? noticeDto;
  bool hasError;
  String id;

  Notice({required this.documentSnapshot,required this.id ,required this.noticeDto, required this.hasError});

  factory Notice.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    try{
      return Notice(
          documentSnapshot: documentSnapshot,
          noticeDto: NoticeDto.fromMap(documentSnapshot.data() as Map<String , dynamic>),
          hasError: false,
          id : documentSnapshot.id
      );
    }catch(e,s){
     StaticLogger.logger.e("$e\n$s");
     return Notice(
         documentSnapshot: documentSnapshot,
         noticeDto: null,
         hasError: true,
         id : documentSnapshot.id
     );
    }
  }
}