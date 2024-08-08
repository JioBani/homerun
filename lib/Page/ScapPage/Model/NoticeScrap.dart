import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Page/ScapPage/Model/NoticeScrapDto.dart';

class NoticeScrap{
  final DocumentSnapshot documentSnapshot;
  final NoticeScrapDto noticeScrapDto;

  NoticeScrap({required this.documentSnapshot, required this.noticeScrapDto});
}