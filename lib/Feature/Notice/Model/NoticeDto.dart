import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Feature/Notice/Model/ApplyHomeDto.dart';
import 'package:homerun/Feature/Notice/Value/SupplyMethod.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Feature/Notice/Value/NoticeDtoFields.dart';

import '../Value/Region.dart';

class NoticeDto{
  final String noticeId;
  final int views;
  final int likes;
  final int scraps;
  final String houseName;
  final SupplyMethod supplyMethod;
  final Region? region;
  final String? detailRegion;
  
  /// 청약 접수 시작일
  final Timestamp subscriptionReceptionStartDate;
  
  /// 분양 공고일
  final Timestamp recruitmentPublicAnnouncementDate;

  final ApplyHomeDto applyHomeDto;

  NoticeDto({
    required this.noticeId,
    required this.views,
    required this.likes,
    required this.scraps,
    required this.houseName,
    required this.subscriptionReceptionStartDate,
    required this.recruitmentPublicAnnouncementDate,
    required this.supplyMethod,
    required this.applyHomeDto,
    this.region,
    this.detailRegion,
  });

  factory NoticeDto.fromMap(Map<String, dynamic> map) {
    SupplyMethod supplyMethod = SupplyMethodExtension.fromString(map[NoticeDtoFields.supplyMethod] as String);

    return NoticeDto(
      noticeId: map[NoticeDtoFields.noticeId] as String,
      views: map[NoticeDtoFields.views] as int,
      likes: map[NoticeDtoFields.likes] as int,
      scraps: map[NoticeDtoFields.scraps] as int,
      houseName: map[NoticeDtoFields.houseName] as String,
      subscriptionReceptionStartDate: map[NoticeDtoFields.subscriptionReceptionStartDate] as Timestamp,
      recruitmentPublicAnnouncementDate: map[NoticeDtoFields.recruitmentPublicAnnouncementDate] as Timestamp,
      supplyMethod: supplyMethod,
      applyHomeDto : ApplyHomeDto.fromMap(map[NoticeDtoFields.info] as Map<String, dynamic>, supplyMethod),
      region : Region.fromKoreanString(map[NoticeDtoFields.region]),
      detailRegion : map[NoticeDtoFields.detailRegion],
    );
  }

  static NoticeDto? tryFromMap(Map<String, dynamic> map){
    try{
      return NoticeDto.fromMap(map);
    }catch(e,s){
      StaticLogger.logger.e("[NoticeDto.tryFromMap()] $e\n$s");
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      NoticeDtoFields.noticeId: noticeId,
      NoticeDtoFields.views: views,
      NoticeDtoFields.likes: likes,
      NoticeDtoFields.scraps: scraps,
      NoticeDtoFields.houseName: houseName,
      NoticeDtoFields.subscriptionReceptionStartDate: subscriptionReceptionStartDate,
      NoticeDtoFields.recruitmentPublicAnnouncementDate: recruitmentPublicAnnouncementDate,
    };
  }
}
