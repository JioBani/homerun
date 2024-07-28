class ApplyhomeCodeConverter {

  ///공급지역 코드
  static final Map<String, String> regionCodes = {
    '100': '서울',
    '200': '강원',
    '300': '대전',
    '312': '충남',
    '338': '세종',
    '360': '충북',
    '400': '인천',
    '410': '경기',
    '500': '광주',
    '513': '전남',
    '560': '전북',
    '600': '부산',
    '621': '경남',
    '680': '울산',
    '690': '제주',
    '700': '대구',
    '712': '경북',
  };

  ///공급지역 코드
  static String convertRegionCode(String code) {
    return regionCodes[code] ?? 'Unknown Code';
  }

  static String tryConvertRegionCode(String? code) {
    if(code == null){
      return "";
    }
    else{
      return regionCodes[code] ?? "";
    }
  }

  ///주택상세구분 코드(APT)
  static final Map<String, String> aptTypeDetailCodes = {
    '01': '민영',
    '03': '국민',
  };

  ///주택상세구분 코드(APT)
  static String convertAptDetailCode(String code) {
    return aptTypeDetailCodes[code] ?? 'Unknown Code';
  }


  ///주택상세구분 코드(오피스텔/도시형/민간임대)
  static final Map<String, String> etcTypeDetailCodes = {
    '01': '도시형생활주택',
    '02': '오피스텔',
    '03': '민간임대/공공지원민간임대',
    '04': '생활형숙박시설',
  };

  ///주택상세구분 코드(오피스텔/도시형/민간임대)
  static String convertEctDetailCode(String code) {
    return etcTypeDetailCodes[code] ?? 'Unknown Code';
  }


  ///분양구분 코드 (APT)
  static final Map<String, String> salesTypeCodes = {
    '0': '분양주택',
    '1': '분양전환 가능임대',
  };

  ///분양구분 코드 (APT)
  static String convertSalesTypeCode(String code) {
    return salesTypeCodes[code] ?? 'Unknown Code';
  }


  ///조정대상지역 코드 (APT)
  static final Map<String, String> adjustedAreaCodes = {
    'Y': '과열지역',
    'N': '미대상주택',
  };

  ///조정대상지역 코드 (APT)
  static String convertAdjustedAreaCode(String code) {
    return adjustedAreaCodes[code] ?? 'Unknown Code';
  }







}
