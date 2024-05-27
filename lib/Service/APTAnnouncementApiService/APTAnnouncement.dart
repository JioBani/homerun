class APTAnnouncement {
  /// 주택 관리 번호
  final String? houseManageNumber;

  /// 공고 번호
  final String? publicAnnouncementNumber;

  /// 주택 구분 코드
  final String? houseSectionCode;

  /// 공급 지역명
  final String? subscriptionAreaName;

  /// 모집 공고일
  final String? recruitmentPublicAnnouncementDate;

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

  /// 청약 접수 시작일
  final String? applicationReceptionStartDate;

  /// 청약 접수 종료일
  final String? applicationReceptionEndDate;

  /// 특별 공급 접수 시작일
  final String? specialSupplyReceptionStartDate;

  /// 특별 공급 접수 종료일
  final String? specialSupplyReceptionEndDate;

  /// 1순위 해당지역 접수 시작일
  final String? generalRank1CorrespondingAreaReceptionStartDate;

  /// 1순위 해당지역 접수 종료일
  final String? generalRank1CorrespondingAreaReceptionEndDate;

  /// 1순위 기타지역 접수 시작일
  final String? generalRank1OtherAreaReceptionStartDate;

  /// 1순위 기타지역 접수 종료일
  final String? generalRank1OtherAreaReceptionEndDate;

  /// 2순위 해당지역 접수 시작일
  final String? generalRank2CorrespondingAreaReceptionStartDate;

  /// 2순위 해당지역 접수 종료일
  final String? generalRank2CorrespondingAreaReceptionEndDate;

  /// 2순위 기타지역 접수 시작일
  final String? generalRank2OtherAreaReceptionStartDate;

  /// 2순위 기타지역 접수 종료일
  final String? generalRank2OtherAreaReceptionEndDate;

  /// 당첨자 발표일
  final String? prizeWinnerAnnouncementDate;

  /// 계약 시작일
  final String? contractConclusionStartDate;

  /// 계약 종료일
  final String? contractConclusionEndDate;

  /// 홈페이지 주소
  final String? homepageAddress;

  /// 건설업체명 (시공사)
  final String? constructionEnterpriseName;

  /// 문의처 전화번호
  final String? inquiryTelephone;

  /// 사업 주체명 (시행사)
  final String? businessEntityName;

  /// 입주 예정 월
  final String? moveInPrearrangeYearMonth;

  /// 투기과열지구 여부
  final String? speculationOverheatedDistrict;

  /// 조정대상지역 여부
  final String? marketAdjustmentTargetAreaSection;

  /// 분양가 상한제 여부
  final String? priceCapApplication;

  /// 정비사업 여부
  final String? redevelopmentBusiness;

  /// 공공주택지구 여부
  final String? publicHousingDistrict;

  /// 대규모 택지개발지구 여부
  final String? largeScaleDevelopmentDistrict;

  /// 수도권 내 민영 공공주택지구 여부
  final String? capitalRegionPrivatePublicHousingDistrict;

  /// 공공주택 특별법 적용 여부
  final String? publicHousingSpecialLawApplication;

  /// 분양정보 URL
  final String? publicAnnouncementUrl;

  APTAnnouncement({
    this.houseManageNumber,
    this.publicAnnouncementNumber,
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
    this.applicationReceptionStartDate,
    this.applicationReceptionEndDate,
    this.specialSupplyReceptionStartDate,
    this.specialSupplyReceptionEndDate,
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

  factory APTAnnouncement.fromMap(Map<String, dynamic> map) {
    return APTAnnouncement(
      houseManageNumber: map['HOUSE_MANAGE_NO'] as String?,
      publicAnnouncementNumber: map['PBLANC_NO'] as String?,
      houseSectionCode: map['HOUSE_SECD'] as String?,
      subscriptionAreaName: map['SUBSCRPT_AREA_CODE_NM'] as String?,
      recruitmentPublicAnnouncementDate: map['RCRIT_PBLANC_DE'] as String?,
      houseName: map['HOUSE_NM'] as String?,
      houseSectionName: map['HOUSE_SECD_NM'] as String?,
      houseDetailSectionCode: map['HOUSE_DTL_SECD'] as String?,
      houseDetailSectionName: map['HOUSE_DTL_SECD_NM'] as String?,
      rentalSectionCode: map['RENT_SECD'] as String?,
      rentalSectionName: map['RENT_SECD_NM'] as String?,
      subscriptionAreaCode: map['SUBSCRPT_AREA_CODE'] as String?,
      supplyLocationZipCode: map['HSSPLY_ZIP'] as String?,
      supplyLocationAddress: map['HSSPLY_ADRES'] as String?,
      totalSupplyHouseholdCount: map['TOT_SUPLY_HSHLDCO'] as int?,
      applicationReceptionStartDate: map['RCEPT_BGNDE'] as String?,
      applicationReceptionEndDate: map['RCEPT_ENDDE'] as String?,
      specialSupplyReceptionStartDate: map['SPSPLY_RCEPT_BGNDE'] as String?,
      specialSupplyReceptionEndDate: map['SPSPLY_RCEPT_ENDDE'] as String?,
      generalRank1CorrespondingAreaReceptionStartDate: map['GNRL_RNK1_CRSPAREA_RCPTDE'] as String?,
      generalRank1CorrespondingAreaReceptionEndDate: map['GNRL_RNK1_CRSPAREA_ENDDE'] as String?,
      generalRank1OtherAreaReceptionStartDate: map['GNRL_RNK1_ETC_AREA_RCPTDE'] as String?,
      generalRank1OtherAreaReceptionEndDate: map['GNRL_RNK1_ETC_AREA_ENDDE'] as String?,
      generalRank2CorrespondingAreaReceptionStartDate: map['GNRL_RNK2_CRSPAREA_RCPTDE'] as String?,
      generalRank2CorrespondingAreaReceptionEndDate: map['GNRL_RNK2_CRSPAREA_ENDDE'] as String?,
      generalRank2OtherAreaReceptionStartDate: map['GNRL_RNK2_ETC_AREA_RCPTDE'] as String?,
      generalRank2OtherAreaReceptionEndDate: map['GNRL_RNK2_ETC_AREA_ENDDE'] as String?,
      prizeWinnerAnnouncementDate: map['PRZWNER_PRESNATN_DE'] as String?,
      contractConclusionStartDate: map['CNTRCT_CNCLS_BGNDE'] as String?,
      contractConclusionEndDate: map['CNTRCT_CNCLS_ENDDE'] as String?,
      homepageAddress: map['HMPG_ADRES'] as String?,
      constructionEnterpriseName: map['CNSTRCT_ENTRPS_NM'] as String?,
      inquiryTelephone: map['MDHS_TELNO'] as String?,
      businessEntityName: map['BSNS_MBY_NM'] as String?,
      moveInPrearrangeYearMonth: map['MVN_PREARNGE_YN'] as String?,
      speculationOverheatedDistrict: map['SPECLT_RDN_EARTH_AT'] as String?,
      marketAdjustmentTargetAreaSection: map['MDAT_TRGET_AREA_SECD'] as String?,
      priceCapApplication: map['PARCPRC_ULS_AT'] as String?,
      redevelopmentBusiness: map['IMPRMN_BSNS_AT'] as String?,
      publicHousingDistrict: map['PUBLIC_HOUSE_EARTH_AT'] as String?,
      largeScaleDevelopmentDistrict: map['LRSCL_BLDLND_AT'] as String?,
      capitalRegionPrivatePublicHousingDistrict: map['NPLN_PRVOPR_PUBLIC_HOUSE_AT'] as String?,
      publicHousingSpecialLawApplication: map['PUBLIC_HOUSE_SPCLM_APPLC_APT'] as String?,
      publicAnnouncementUrl: map['PBLANC_URL'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'HOUSE_MANAGE_NO': houseManageNumber,
      'PBLANC_NO': publicAnnouncementNumber,
      'HOUSE_SECD': houseSectionCode,
      'SUBSCRPT_AREA_CODE_NM': subscriptionAreaName,
      'RCRIT_PBLANC_DE': recruitmentPublicAnnouncementDate,
      'HOUSE_NM': houseName,
      'HOUSE_SECD_NM': houseSectionName,
      'HOUSE_DTL_SECD': houseDetailSectionCode,
      'HOUSE_DTL_SECD_NM': houseDetailSectionName,
      'RENT_SECD': rentalSectionCode,
      'RENT_SECD_NM': rentalSectionName,
      'SUBSCRPT_AREA_CODE': subscriptionAreaCode,
      'HSSPLY_ZIP': supplyLocationZipCode,
      'HSSPLY_ADRES': supplyLocationAddress,
      'TOT_SUPLY_HSHLDCO': totalSupplyHouseholdCount,
      'RCEPT_BGNDE': applicationReceptionStartDate,
      'RCEPT_ENDDE': applicationReceptionEndDate,
      'SPSPLY_RCEPT_BGNDE': specialSupplyReceptionStartDate,
      'SPSPLY_RCEPT_ENDDE': specialSupplyReceptionEndDate,
      'GNRL_RNK1_CRSPAREA_RCPTDE': generalRank1CorrespondingAreaReceptionStartDate,
      'GNRL_RNK1_CRSPAREA_ENDDE': generalRank1CorrespondingAreaReceptionEndDate,
      'GNRL_RNK1_ETC_AREA_RCPTDE': generalRank1OtherAreaReceptionStartDate,
      'GNRL_RNK1_ETC_AREA_ENDDE': generalRank1OtherAreaReceptionEndDate,
      'GNRL_RNK2_CRSPAREA_RCPTDE': generalRank2CorrespondingAreaReceptionStartDate,
      'GNRL_RNK2_CRSPAREA_ENDDE': generalRank2CorrespondingAreaReceptionEndDate,
      'GNRL_RNK2_ETC_AREA_RCPTDE': generalRank2OtherAreaReceptionStartDate,
      'GNRL_RNK2_ETC_AREA_ENDDE': generalRank2OtherAreaReceptionEndDate,
      'PRZWNER_PRESNATN_DE': prizeWinnerAnnouncementDate,
      'CNTRCT_CNCLS_BGNDE': contractConclusionStartDate,
      'CNTRCT_CNCLS_ENDDE': contractConclusionEndDate,
      'HMPG_ADRES': homepageAddress,
      'CNSTRCT_ENTRPS_NM': constructionEnterpriseName,
      'MDHS_TELNO': inquiryTelephone,
      'BSNS_MBY_NM': businessEntityName,
      'MVN_PREARNGE_YN': moveInPrearrangeYearMonth,
      'SPECLT_RDN_EARTH_AT': speculationOverheatedDistrict,
      'MDAT_TRGET_AREA_SECD': marketAdjustmentTargetAreaSection,
      'PARCPRC_ULS_AT': priceCapApplication,
      'IMPRMN_BSNS_AT': redevelopmentBusiness,
      'PUBLIC_HOUSE_EARTH_AT': publicHousingDistrict,
      'LRSCL_BLDLND_AT': largeScaleDevelopmentDistrict,
      'NPLN_PRVOPR_PUBLIC_HOUSE_AT': capitalRegionPrivatePublicHousingDistrict,
      'PUBLIC_HOUSE_SPCLM_APPLC_APT': publicHousingSpecialLawApplication,
      'PBLANC_URL': publicAnnouncementUrl,
    };
  }
}
