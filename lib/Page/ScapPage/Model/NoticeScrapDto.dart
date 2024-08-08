import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Page/ScapPage/Value/NoticeScrapDtoFields.dart';

class NoticeScrapDto{
  final String noticeId;
  final Timestamp date;

  NoticeScrapDto({required this.noticeId, required this.date});

  factory NoticeScrapDto.fromMap(Map<String,dynamic> map){
    return NoticeScrapDto(
        noticeId: map[NoticeScrapDtoFields.noticeId],
        date: map[NoticeScrapDtoFields.date]
    );
  }

  factory NoticeScrapDto.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    return NoticeScrapDto.fromMap(documentSnapshot.data() as Map<String,dynamic>);
  }
}