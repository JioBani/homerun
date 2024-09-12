import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/Page/NoticesPage/Value/NoticeDtoFields.dart';
import 'package:homerun/Service/APTAnnouncementApiService/AptAnnouncementByHouseType.dart';
import 'package:homerun/Service/APTAnnouncementApiService/ProcessedAPTAnnouncementByHouseType.dart';

class NoticeDto {
  final String noticeId;
  final int views;
  final int likes;
  final int scraps;
  final String houseName;
  
  /// 청약 접수 시작일
  final Timestamp applicationReceptionStartDate;
  
  /// 분양 공고일
  final Timestamp recruitmentPublicAnnouncementDate;

  final APTAnnouncement? info;
  final List<AptAnnouncementByHouseType?>? aptAnnouncementByTypeList;
  final ProcessedAPTAnnouncementByHouseType? processedAPTAnnouncementByHouseType;

  NoticeDto({
    required this.noticeId,
    required this.views,
    required this.likes,
    required this.scraps,
    required this.houseName,
    required this.applicationReceptionStartDate,
    required this.recruitmentPublicAnnouncementDate,
    required this.aptAnnouncementByTypeList,
    required this.processedAPTAnnouncementByHouseType,
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
      aptAnnouncementByTypeList: AptAnnouncementByHouseType.tryMakeList(
          map[NoticeDtoFields.aptAnnouncementByTypeList] as List<dynamic>?
      ),
      processedAPTAnnouncementByHouseType: ProcessedAPTAnnouncementByHouseType.tryFromMap(
          map[NoticeDtoFields.processedAPTAnnouncementByHouseType]
      ),
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
      NoticeDtoFields.aptAnnouncementByTypeList: aptAnnouncementByTypeList?.map((e)=>e?.toMap()),
      NoticeDtoFields.processedAPTAnnouncementByHouseType: processedAPTAnnouncementByHouseType?.toMap(),
    };
  }
}
