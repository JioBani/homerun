import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Feature/Notice/Model/Notice.dart';
import 'package:homerun/Page/ScapPage/Model/NoticeScrapDto.dart';

class NoticeScrap{
  final DocumentSnapshot documentSnapshot;
  final NoticeScrapDto noticeScrapDto;
  final Notice? notice;

  NoticeScrap({required this.documentSnapshot, required this.noticeScrapDto , this.notice});
}