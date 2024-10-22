enum HouseType {
  /// 국민주택
  NationalHousing('국민주택', 'NationalHousing'),

  /// 민영주택
  PrivateHousing('민영주택', 'PrivateHousing'),

  /// 신혼희망타운
  NewlywedsHopeTown('신혼희망타운', 'NewlywedsHopeTown'),

  /// 분양전환가능임대주택
  ConvertibleLeaseHousing('분양전환임대주택', 'ConvertibleLeaseHousing');

  // 한글 및 영어 문자열 값
  final String koreanName;
  final String englishName;
  const HouseType(this.koreanName, this.englishName);

  @override
  String toString() => koreanName;

  // 대문자 카멜케이스로 영어 문자열 반환 함수
  String toEngString() => englishName;

  static HouseType? fromKoreanString(String label) {
    for (var value in HouseType.values) {
      if (value.koreanName == label) {
        return value;
      }
    }
    return null;
  }
}
