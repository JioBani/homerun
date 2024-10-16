import 'package:cloud_firestore/cloud_firestore.dart';

import '../Value/AptDetailsInfoFields.dart';

class AptDetailsInfo {
  /// 주택관리번호
  final String houseManageNumber;

  /// 공고번호
  final String publicAnnouncementNumber;

  /// 모델번호
  final String? modelNumber;

  /// 주택형
  final String? houseType;

  /// 공급면적
  final String? supplyArea;

  /// 일반공급세대수
  final int? generalSupplyHouseholds;

  /// 특별공급세대수
  final int? specialSupplyHouseholds;

  /// 특별공급 - 다자녀가구 세대수
  final int? multiChildHouseholds;

  /// 특별공급 - 신혼부부 세대수
  final int? newlywedHouseholds;

  /// 특별공급 - 생애최초 세대수
  final int? firstTimeHouseholds;

  /// 특별공급 - 노부모부양 세대수
  final int? elderlyParentSupportHouseholds;

  /// 특별공급 - 기관추천 세대수
  final int? institutionRecommendedHouseholds;

  /// 특별공급 - 기타 세대수
  final int? otherSpecialHouseholds;

  /// 특별공급 - 이전기관 세대수
  final int? relocatedInstitutionHouseholds;

  /// 특별공급 - 청년 세대수
  final int? youthHouseholds;

  /// 특별공급 - 신생아 세대수
  final int? newbornHouseholds;

  /// 공급금액(분양최고금액)
  final double? topAmount;

  AptDetailsInfo({
    required this.houseManageNumber,
    required this.publicAnnouncementNumber,
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
    this.topAmount,
  });

  /// fromMap 팩토리 생성자 - 필드명을 AptDetailsInfoFields에서 가져오는 생성자
  factory AptDetailsInfo.fromMap(Map<String, dynamic> map) {
    return AptDetailsInfo(
      houseManageNumber: map[AptDetailsInfoFields.houseManageNumber] as String,
      publicAnnouncementNumber: map[AptDetailsInfoFields.publicAnnouncementNumber] as String,
      modelNumber: map[AptDetailsInfoFields.modelNumber] as String?,
      houseType: map[AptDetailsInfoFields.houseType] as String?,
      supplyArea: map[AptDetailsInfoFields.supplyArea] as String?,
      generalSupplyHouseholds: map[AptDetailsInfoFields.generalSupplyHouseholds] as int?,
      specialSupplyHouseholds: map[AptDetailsInfoFields.specialSupplyHouseholds] as int?,
      multiChildHouseholds: map[AptDetailsInfoFields.multiChildHouseholds] as int?,
      newlywedHouseholds: map[AptDetailsInfoFields.newlywedHouseholds] as int?,
      firstTimeHouseholds: map[AptDetailsInfoFields.firstTimeHouseholds] as int?,
      elderlyParentSupportHouseholds: map[AptDetailsInfoFields.elderlyParentSupportHouseholds] as int?,
      institutionRecommendedHouseholds: map[AptDetailsInfoFields.institutionRecommendedHouseholds] as int?,
      otherSpecialHouseholds: map[AptDetailsInfoFields.otherSpecialHouseholds] as int?,
      relocatedInstitutionHouseholds: map[AptDetailsInfoFields.relocatedInstitutionHouseholds] as int?,
      youthHouseholds: map[AptDetailsInfoFields.youthHouseholds] as int?,
      newbornHouseholds: map[AptDetailsInfoFields.newbornHouseholds] as int?,
      topAmount: double.tryParse(map[AptDetailsInfoFields.topAmount].toString()),
    );
  }

  /// 현재 객체를 맵으로 변환합니다.
  Map<String, dynamic> toMap() {
    return {
      AptDetailsInfoFields.houseManageNumber: houseManageNumber,
      AptDetailsInfoFields.publicAnnouncementNumber: publicAnnouncementNumber,
      AptDetailsInfoFields.modelNumber: modelNumber,
      AptDetailsInfoFields.houseType: houseType,
      AptDetailsInfoFields.supplyArea: supplyArea,
      AptDetailsInfoFields.generalSupplyHouseholds: generalSupplyHouseholds,
      AptDetailsInfoFields.specialSupplyHouseholds: specialSupplyHouseholds,
      AptDetailsInfoFields.multiChildHouseholds: multiChildHouseholds,
      AptDetailsInfoFields.newlywedHouseholds: newlywedHouseholds,
      AptDetailsInfoFields.firstTimeHouseholds: firstTimeHouseholds,
      AptDetailsInfoFields.elderlyParentSupportHouseholds: elderlyParentSupportHouseholds,
      AptDetailsInfoFields.institutionRecommendedHouseholds: institutionRecommendedHouseholds,
      AptDetailsInfoFields.otherSpecialHouseholds: otherSpecialHouseholds,
      AptDetailsInfoFields.relocatedInstitutionHouseholds: relocatedInstitutionHouseholds,
      AptDetailsInfoFields.youthHouseholds: youthHouseholds,
      AptDetailsInfoFields.newbornHouseholds: newbornHouseholds,
      AptDetailsInfoFields.topAmount: topAmount,
    };
  }
}
