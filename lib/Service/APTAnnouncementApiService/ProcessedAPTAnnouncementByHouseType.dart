import 'package:homerun/Common/StaticLogger.dart';

import 'ProcessedAPTAnnouncementByHouseTypeField.dart';

class ProcessedAPTAnnouncementByHouseType {
  /// 특별공급 전체 세대수.
  int? totalSpecialSupplyHouseholds;

  /// 일반공급 전체 세대수.
  int? totalGeneralSupplyHouseholds;

  /// 최대 공급금액.
  double? maxSupplyPrice;

  /// 최소 공급금액.
  double? minSupplyPrice;

  /// 공급 규모에 에러가 있는지 확인.
  bool hasSupplyHouseholdsCountError;

  ProcessedAPTAnnouncementByHouseType({
    this.totalSpecialSupplyHouseholds,
    this.totalGeneralSupplyHouseholds,
    this.maxSupplyPrice,
    this.minSupplyPrice,
    required this.hasSupplyHouseholdsCountError,
  });

  /// 주어진 맵으로부터 ProcessedAPTAnnouncementByHouseType 객체를 생성합니다.
  factory ProcessedAPTAnnouncementByHouseType.fromMap(Map<String, dynamic> map) {
    return ProcessedAPTAnnouncementByHouseType(
      totalSpecialSupplyHouseholds: map[ProcessedAPTAnnouncementByHouseTypeField.totalSpecialSupplyHouseholds] as int?,
      totalGeneralSupplyHouseholds: map[ProcessedAPTAnnouncementByHouseTypeField.totalGeneralSupplyHouseholds] as int?,
      maxSupplyPrice: (map[ProcessedAPTAnnouncementByHouseTypeField.maxSupplyPrice] as num?)?.toDouble(),
      minSupplyPrice: (map[ProcessedAPTAnnouncementByHouseTypeField.minSupplyPrice] as num?)?.toDouble(),
      hasSupplyHouseholdsCountError: map[ProcessedAPTAnnouncementByHouseTypeField.hasSupplyHouseholdsCountError] as bool,
    );
  }

  /// 객체를 맵 형태로 변환합니다.
  Map<String, dynamic> toMap() {
    return {
      ProcessedAPTAnnouncementByHouseTypeField.totalSpecialSupplyHouseholds: totalSpecialSupplyHouseholds,
      ProcessedAPTAnnouncementByHouseTypeField.totalGeneralSupplyHouseholds: totalGeneralSupplyHouseholds,
      ProcessedAPTAnnouncementByHouseTypeField.maxSupplyPrice: maxSupplyPrice,
      ProcessedAPTAnnouncementByHouseTypeField.minSupplyPrice: minSupplyPrice,
      ProcessedAPTAnnouncementByHouseTypeField.hasSupplyHouseholdsCountError: hasSupplyHouseholdsCountError,
    };
  }

  static ProcessedAPTAnnouncementByHouseType? tryFromMap(Map<String, dynamic> map) {
    try{
      return ProcessedAPTAnnouncementByHouseType.fromMap(map);
    }catch(e,s){
      StaticLogger.logger.e("[ProcessedAPTAnnouncementByHouseType.tryFromMap()] $e\n$s");
      return null;
    }
  }
}