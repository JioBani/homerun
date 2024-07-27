import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/Page/NoticesPage/Value/NoticeDtoFields.dart';

class NoticeDto {
  final String noticeId;
  final int views;
  final int likes;
  final int scraps;
  final String houseName;
  final Timestamp applicationReceptionStartDate;
  final Timestamp recruitmentPublicAnnouncementDate;
  final APTAnnouncement? info;

  NoticeDto({
    required this.noticeId,
    required this.views,
    required this.likes,
    required this.scraps,
    required this.houseName,
    required this.applicationReceptionStartDate,
    required this.recruitmentPublicAnnouncementDate,
    required this.info,
  });

  factory NoticeDto.fromMap(Map<String, dynamic> map) {
    APTAnnouncement? announcement;
    try{
      announcement = APTAnnouncement.fromMap(map[NoticeDtoFields.info]);
    }catch(e , s){
      StaticLogger.logger.e("$e\n$s");
    }
    return NoticeDto(
      noticeId: map[NoticeDtoFields.noticeId] as String,
      views: map[NoticeDtoFields.views] as int,
      likes: map[NoticeDtoFields.likes] as int,
      scraps: map[NoticeDtoFields.scraps] as int,
      houseName: map[NoticeDtoFields.houseName] as String,
      applicationReceptionStartDate: map[NoticeDtoFields.applicationReceptionStartDate] as Timestamp,
      recruitmentPublicAnnouncementDate: map[NoticeDtoFields.recruitmentPublicAnnouncementDate] as Timestamp,
      info: announcement,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      NoticeDtoFields.noticeId: noticeId,
      NoticeDtoFields.views: views,
      NoticeDtoFields.likes: likes,
      NoticeDtoFields.scraps: scraps,
      NoticeDtoFields.houseName: houseName,
      NoticeDtoFields.applicationReceptionStartDate: applicationReceptionStartDate,
      NoticeDtoFields.recruitmentPublicAnnouncementDate: recruitmentPublicAnnouncementDate,
      NoticeDtoFields.info: info?.toMap(),
    };
  }
}
