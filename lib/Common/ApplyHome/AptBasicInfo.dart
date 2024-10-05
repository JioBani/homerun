import 'package:cloud_firestore/cloud_firestore.dart';

import 'AptBasicInfoFields.dart';

class AptBasicInfo {
  /// 주택관리번호
  final String houseManageNumber;

  /// 공고번호
  final String publicAnnouncementNumber;

  /// 주택 구분 코드
  final String? houseSectionCode;

  /// 공급 지역명
  final String? subscriptionAreaName;

  /// 모집 공고일 (Firebase Timestamp)
  final Timestamp? recruitmentPublicAnnouncementDate;

  /// 주택명
  final String? houseName;

  /// 주택 구분 코드명
  final String? houseSectionName;

  /// 주택 상세 구분 코드
  final String? houseDetailSectionCode;

  /// 주택 상세 구분 코드명
  final String? houseDetailSectionName;

  /// 분양 구분 코드
  final String? rentalSectionCode;

  /// 분양 구분 코드명
  final String? rentalSectionName;

  /// 공급 지역 코드
  final String? subscriptionAreaCode;

  /// 공급 위치 우편번호
  final String? supplyLocationZipCode;

  /// 공급 위치 주소
  final String? supplyLocationAddress;

  /// 공급 규모 (가구 수)
  final int? totalSupplyHouseholdCount;

  /// 청약 접수 시작일 (Firebase Timestamp)
  final Timestamp? subscriptionReceptionStartDate;

  /// 청약 접수 종료일 (Firebase Timestamp)
  final Timestamp? subscriptionReceptionEndDate;

  /// 일반 공급 접수 시작일 (Firebase Timestamp)
  final Timestamp? generalSupplyReceptionStartDate;

  /// 일반 공급 접수 종료일 (Firebase Timestamp)
  final Timestamp? generalSupplyReceptionEndDate;

  /// 특별 공급 접수 시작일 (Firebase Timestamp)
  final Timestamp? specialSupplyReceptionStartDate;

  /// 특별 공급 접수 종료일 (Firebase Timestamp)
  final Timestamp? specialSupplyReceptionEndDate;

  /// 1순위 해당지역 접수 시작일 (Firebase Timestamp)
  final Timestamp? generalRank1CorrespondingAreaReceptionStartDate;

  /// 1순위 해당지역 접수 종료일 (Firebase Timestamp)
  final Timestamp? generalRank1CorrespondingAreaReceptionEndDate;

  /// 1순위 기타지역 접수 시작일 (Firebase Timestamp)
  final Timestamp? generalRank1OtherAreaReceptionStartDate;

  /// 1순위 기타지역 접수 종료일 (Firebase Timestamp)
  final Timestamp? generalRank1OtherAreaReceptionEndDate;

  /// 2순위 해당지역 접수 시작일 (Firebase Timestamp)
  final Timestamp? generalRank2CorrespondingAreaReceptionStartDate;

  /// 2순위 해당지역 접수 종료일 (Firebase Timestamp)
  final Timestamp? generalRank2CorrespondingAreaReceptionEndDate;

  /// 2순위 기타지역 접수 시작일 (Firebase Timestamp)
  final Timestamp? generalRank2OtherAreaReceptionStartDate;

  /// 2순위 기타지역 접수 종료일 (Firebase Timestamp)
  final Timestamp? generalRank2OtherAreaReceptionEndDate;

  /// 당첨자 발표일 (Firebase Timestamp)
  final Timestamp? prizeWinnerAnnouncementDate;

  /// 계약 시작일 (Firebase Timestamp)
  final Timestamp? contractConclusionStartDate;

  /// 계약 종료일 (Firebase Timestamp)
  final Timestamp? contractConclusionEndDate;

  /// 홈페이지 주소
  final String? homepageAddress;

  /// 건설업체명 (시공사)
  final String? constructionEnterpriseName;

  /// 문의처 전화번호
  final String? inquiryTelephone;

  /// 사업주체명 (시행사)
  final String? businessEntityName;

  /// 입주 예정 월
  final String? moveInPrearrangeYearMonth;

  /// 투기 과열 지구 여부
  final String? speculationOverheatedDistrict;

  /// 조정 대상 지역 여부
  final String? marketAdjustmentTargetAreaSection;

  /// 분양가 상한제 여부
  final String? priceCapApplication;

  /// 정비 사업 여부
  final String? redevelopmentBusiness;

  /// 공공 주택 지구 여부
  final String? publicHousingDistrict;

  /// 대규모 택지 개발 지구 여부
  final String? largeScaleDevelopmentDistrict;

  /// 수도권 내 민영 공공주택지구 여부
  final String? capitalRegionPrivatePublicHousingDistrict;

  /// 공공주택 특별법 적용 여부
  final String? publicHousingSpecialLawApplication;

  /// 분양 정보 URL
  final String? publicAnnouncementUrl;

  // Constructor
  AptBasicInfo({
    required this.houseManageNumber,
    required this.publicAnnouncementNumber,
    this.houseSectionCode,
    this.subscriptionAreaName,
    this.recruitmentPublicAnnouncementDate,
    this.houseName,
    this.houseSectionName,
    this.houseDetailSectionCode,
    this.houseDetailSectionName,
    this.rentalSectionCode,
    this.rentalSectionName,
    this.subscriptionAreaCode,
    this.supplyLocationZipCode,
    this.supplyLocationAddress,
    this.totalSupplyHouseholdCount,
    this.subscriptionReceptionStartDate,
    this.subscriptionReceptionEndDate,
    this.specialSupplyReceptionStartDate,
    this.specialSupplyReceptionEndDate,
    this.generalSupplyReceptionStartDate,
    this.generalSupplyReceptionEndDate,
    this.generalRank1CorrespondingAreaReceptionStartDate,
    this.generalRank1CorrespondingAreaReceptionEndDate,
    this.generalRank1OtherAreaReceptionStartDate,
    this.generalRank1OtherAreaReceptionEndDate,
    this.generalRank2CorrespondingAreaReceptionStartDate,
    this.generalRank2CorrespondingAreaReceptionEndDate,
    this.generalRank2OtherAreaReceptionStartDate,
    this.generalRank2OtherAreaReceptionEndDate,
    this.prizeWinnerAnnouncementDate,
    this.contractConclusionStartDate,
    this.contractConclusionEndDate,
    this.homepageAddress,
    this.constructionEnterpriseName,
    this.inquiryTelephone,
    this.businessEntityName,
    this.moveInPrearrangeYearMonth,
    this.speculationOverheatedDistrict,
    this.marketAdjustmentTargetAreaSection,
    this.priceCapApplication,
    this.redevelopmentBusiness,
    this.publicHousingDistrict,
    this.largeScaleDevelopmentDistrict,
    this.capitalRegionPrivatePublicHousingDistrict,
    this.publicHousingSpecialLawApplication,
    this.publicAnnouncementUrl,
  });

  factory AptBasicInfo.fromMap(Map<String, dynamic> map) {
    return AptBasicInfo(
      houseManageNumber: map[AptBasicInfoFields.houseManageNumber] as String,
      publicAnnouncementNumber: map[AptBasicInfoFields.publicAnnouncementNumber] as String,
      houseSectionCode: map[AptBasicInfoFields.houseSectionCode] as String?,
      subscriptionAreaName: map[AptBasicInfoFields.subscriptionAreaName] as String?,
      recruitmentPublicAnnouncementDate: map[AptBasicInfoFields.recruitmentPublicAnnouncementDate] as Timestamp?,
      houseName: map[AptBasicInfoFields.houseName] as String?,
      houseSectionName: map[AptBasicInfoFields.houseSectionName] as String?,
      houseDetailSectionCode: map[AptBasicInfoFields.houseDetailSectionCode] as String?,
      houseDetailSectionName: map[AptBasicInfoFields.houseDetailSectionName] as String?,
      rentalSectionCode: map[AptBasicInfoFields.rentalSectionCode] as String?,
      rentalSectionName: map[AptBasicInfoFields.rentalSectionName] as String?,
      subscriptionAreaCode: map[AptBasicInfoFields.subscriptionAreaCode] as String?,
      supplyLocationZipCode: map[AptBasicInfoFields.supplyLocationZipCode] as String?,
      supplyLocationAddress: map[AptBasicInfoFields.supplyLocationAddress] as String?,
      totalSupplyHouseholdCount: map[AptBasicInfoFields.totalSupplyHouseholdCount] as int?,
      subscriptionReceptionStartDate: map[AptBasicInfoFields.subscriptionReceptionStartDate] as Timestamp?,
      subscriptionReceptionEndDate: map[AptBasicInfoFields.subscriptionReceptionEndDate] as Timestamp?,
      specialSupplyReceptionStartDate: map[AptBasicInfoFields.specialSupplyReceptionStartDate] as Timestamp?,
      specialSupplyReceptionEndDate: map[AptBasicInfoFields.specialSupplyReceptionEndDate] as Timestamp?,
      generalSupplyReceptionStartDate: map[AptBasicInfoFields.generalSupplyReceptionStartDate] as Timestamp?,
      generalSupplyReceptionEndDate: map[AptBasicInfoFields.generalSupplyReceptionEndDate] as Timestamp?,
      generalRank1CorrespondingAreaReceptionStartDate: map[AptBasicInfoFields.generalRank1CorrespondingAreaReceptionStartDate] as Timestamp?,
      generalRank1CorrespondingAreaReceptionEndDate: map[AptBasicInfoFields.generalRank1CorrespondingAreaReceptionEndDate] as Timestamp?,
      generalRank1OtherAreaReceptionStartDate: map[AptBasicInfoFields.generalRank1OtherAreaReceptionStartDate] as Timestamp?,
      generalRank1OtherAreaReceptionEndDate: map[AptBasicInfoFields.generalRank1OtherAreaReceptionEndDate] as Timestamp?,
      generalRank2CorrespondingAreaReceptionStartDate: map[AptBasicInfoFields.generalRank2CorrespondingAreaReceptionStartDate] as Timestamp?,
      generalRank2CorrespondingAreaReceptionEndDate: map[AptBasicInfoFields.generalRank2CorrespondingAreaReceptionEndDate] as Timestamp?,
      generalRank2OtherAreaReceptionStartDate: map[AptBasicInfoFields.generalRank2OtherAreaReceptionStartDate] as Timestamp?,
      generalRank2OtherAreaReceptionEndDate: map[AptBasicInfoFields.generalRank2OtherAreaReceptionEndDate] as Timestamp?,
      prizeWinnerAnnouncementDate: map[AptBasicInfoFields.prizeWinnerAnnouncementDate] as Timestamp?,
      contractConclusionStartDate: map[AptBasicInfoFields.contractConclusionStartDate] as Timestamp?,
      contractConclusionEndDate: map[AptBasicInfoFields.contractConclusionEndDate] as Timestamp?,
      homepageAddress: map[AptBasicInfoFields.homepageAddress] as String?,
      constructionEnterpriseName: map[AptBasicInfoFields.constructionEnterpriseName] as String?,
      inquiryTelephone: map[AptBasicInfoFields.inquiryTelephone] as String?,
      businessEntityName: map[AptBasicInfoFields.businessEntityName] as String?,
      moveInPrearrangeYearMonth: map[AptBasicInfoFields.moveInPrearrangeYearMonth] as String?,
      speculationOverheatedDistrict: map[AptBasicInfoFields.speculationOverheatedDistrict] as String?,
      marketAdjustmentTargetAreaSection: map[AptBasicInfoFields.marketAdjustmentTargetAreaSection] as String?,
      priceCapApplication: map[AptBasicInfoFields.priceCapApplication] as String?,
      redevelopmentBusiness: map[AptBasicInfoFields.redevelopmentBusiness] as String?,
      publicHousingDistrict: map[AptBasicInfoFields.publicHousingDistrict] as String?,
      largeScaleDevelopmentDistrict: map[AptBasicInfoFields.largeScaleDevelopmentDistrict] as String?,
      capitalRegionPrivatePublicHousingDistrict: map[AptBasicInfoFields.capitalRegionPrivatePublicHousingDistrict] as String?,
      publicHousingSpecialLawApplication: map[AptBasicInfoFields.publicHousingSpecialLawApplication] as String?,
      publicAnnouncementUrl: map[AptBasicInfoFields.publicAnnouncementUrl] as String?,
    );
  }
}
