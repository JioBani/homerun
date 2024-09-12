
import 'package:homerun/Common/StaticLogger.dart';

import 'AptAnnouncementByHouseTypeField.dart';

/// 주택형별 분양정보를 나타내는 클래스.
/// 각 필드는 API 응답에 맞게 타입이 정의되며, null 가능성도 반영됩니다.
class AptAnnouncementByHouseType {
  /// 주택 관리 번호 (주택관리번호).
  String houseManageNumber;

  /// 공고 번호 (공고번호).
  String publicNoticeNumber;

  /// 모델 번호 (모델번호).
  String? modelNumber;

  /// 주택 형 (주택형).
  String? houseType;

  /// 공급 면적 (공급면적).
  String? supplyArea;

  /// 일반 공급 세대 수 (일반공급세대수).
  int? generalSupplyHouseholds;

  /// 특별 공급 세대 수 (특별공급세대수).
  int? specialSupplyHouseholds;

  /// 특별 공급 - 다자녀 가구 세대 수 (특별공급-다자녀가구 세대수).
  int? multiChildHouseholds;

  /// 특별 공급 - 신혼부부 세대 수 (특별공급-신혼부부 세대수).
  int? newlywedHouseholds;

  /// 특별 공급 - 생애 최초 세대 수 (특별공급-생애최초 세대수).
  int? firstTimeHouseholds;

  /// 특별 공급 - 노부모 부양 세대 수 (특별공급-노부모부양 세대수).
  int? elderlyParentSupportHouseholds;

  /// 특별 공급 - 기관 추천 세대 수 (특별공급-기관추천 세대수).
  int? institutionRecommendedHouseholds;

  /// 특별 공급 - 기타 세대 수 (특별공급-기타 세대수).
  int? otherSpecialHouseholds;

  /// 특별 공급 - 이전 기관 세대 수 (특별공급-이전기관 세대수).
  int? relocatedInstitutionHouseholds;

  /// 특별 공급 - 청년 세대 수 (특별공급-청년 세대수).
  int? youthHouseholds;

  /// 특별 공급 - 신생아 세대 수 (특별공급-신생아 세대수).
  int? newbornHouseholds;

  /// 공급 금액 (분양최고금액) (단위: 만원).
  String? highestSupplyPrice;

  AptAnnouncementByHouseType({
    required this.houseManageNumber,
    required this.publicNoticeNumber,
    this.modelNumber,
    this.houseType,
    this.supplyArea,
    this.generalSupplyHouseholds,
    this.specialSupplyHouseholds,
    this.multiChildHouseholds,
    this.newlywedHouseholds,
    this.firstTimeHouseholds,
    this.elderlyParentSupportHouseholds,
    this.institutionRecommendedHouseholds,
    this.otherSpecialHouseholds,
    this.relocatedInstitutionHouseholds,
    this.youthHouseholds,
    this.newbornHouseholds,
    this.highestSupplyPrice,
  });

  /// 주어진 맵에서 AptAnnouncementByHouseType 객체를 생성합니다.
  factory AptAnnouncementByHouseType.fromMap(Map<String, dynamic> map) {
    return AptAnnouncementByHouseType(
      houseManageNumber: map[AptAnnouncementByHouseTypeField.houseManageNumber] as String,
      publicNoticeNumber: map[AptAnnouncementByHouseTypeField.publicNoticeNumber] as String,
      modelNumber: map[AptAnnouncementByHouseTypeField.modelNumber] as String?,
      houseType: map[AptAnnouncementByHouseTypeField.houseType] as String?,
      supplyArea: map[AptAnnouncementByHouseTypeField.supplyArea] as String?,
      generalSupplyHouseholds: map[AptAnnouncementByHouseTypeField.generalSupplyHouseholds] as int?,
      specialSupplyHouseholds: map[AptAnnouncementByHouseTypeField.specialSupplyHouseholds] as int?,
      multiChildHouseholds: map[AptAnnouncementByHouseTypeField.multiChildHouseholds] as int?,
      newlywedHouseholds: map[AptAnnouncementByHouseTypeField.newlywedHouseholds] as int?,
      firstTimeHouseholds: map[AptAnnouncementByHouseTypeField.firstTimeHouseholds] as int?,
      elderlyParentSupportHouseholds: map[AptAnnouncementByHouseTypeField.elderlyParentSupportHouseholds] as int?,
      institutionRecommendedHouseholds: map[AptAnnouncementByHouseTypeField.institutionRecommendedHouseholds] as int?,
      otherSpecialHouseholds: map[AptAnnouncementByHouseTypeField.otherSpecialHouseholds] as int?,
      relocatedInstitutionHouseholds: map[AptAnnouncementByHouseTypeField.relocatedInstitutionHouseholds] as int?,
      youthHouseholds: map[AptAnnouncementByHouseTypeField.youthHouseholds] as int?,
      newbornHouseholds: map[AptAnnouncementByHouseTypeField.newbornHouseholds] as int?,
      highestSupplyPrice: map[AptAnnouncementByHouseTypeField.highestSupplyPrice] as String?,
    );
  }

  static AptAnnouncementByHouseType? tryFromMap(Map<String, dynamic> map) {
    try{
      return AptAnnouncementByHouseType.fromMap(map);
    }catch(e,s){
      StaticLogger.logger.e("[AptAnnouncementByHouseType.tryFromMap()] $e\n$s");
      return null;
    }
  }

  static List<AptAnnouncementByHouseType?>? tryMakeList(List<dynamic>? list){
    return list?.map((e)=>tryFromMap(e)).toList();
  }

  /// 객체를 맵 형태로 변환합니다.
  Map<String, dynamic> toMap() {
    return {
      AptAnnouncementByHouseTypeField.houseManageNumber: houseManageNumber,
      AptAnnouncementByHouseTypeField.publicNoticeNumber: publicNoticeNumber,
      AptAnnouncementByHouseTypeField.modelNumber: modelNumber,
      AptAnnouncementByHouseTypeField.houseType: houseType,
      AptAnnouncementByHouseTypeField.supplyArea: supplyArea,
      AptAnnouncementByHouseTypeField.generalSupplyHouseholds: generalSupplyHouseholds,
      AptAnnouncementByHouseTypeField.specialSupplyHouseholds: specialSupplyHouseholds,
      AptAnnouncementByHouseTypeField.multiChildHouseholds: multiChildHouseholds,
      AptAnnouncementByHouseTypeField.newlywedHouseholds: newlywedHouseholds,
      AptAnnouncementByHouseTypeField.firstTimeHouseholds: firstTimeHouseholds,
      AptAnnouncementByHouseTypeField.elderlyParentSupportHouseholds: elderlyParentSupportHouseholds,
      AptAnnouncementByHouseTypeField.institutionRecommendedHouseholds: institutionRecommendedHouseholds,
      AptAnnouncementByHouseTypeField.otherSpecialHouseholds: otherSpecialHouseholds,
      AptAnnouncementByHouseTypeField.relocatedInstitutionHouseholds: relocatedInstitutionHouseholds,
      AptAnnouncementByHouseTypeField.youthHouseholds: youthHouseholds,
      AptAnnouncementByHouseTypeField.newbornHouseholds: newbornHouseholds,
      AptAnnouncementByHouseTypeField.highestSupplyPrice: highestSupplyPrice,
    };
  }
}
