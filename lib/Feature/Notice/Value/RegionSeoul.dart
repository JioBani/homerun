enum RegionSeoul {
  /// 종로구
  Jongno('종로구', 'Jongno'),

  /// 중구
  Jung('중구', 'Jung'),

  /// 용산구
  Yongsan('용산구', 'Yongsan'),

  /// 성동구
  Seongdong('성동구', 'Seongdong'),

  /// 광진구
  Gwangjin('광진구', 'Gwangjin'),

  /// 동대문구
  Dongdaemun('동대문구', 'Dongdaemun'),

  /// 중랑구
  Jungnang('중랑구', 'Jungnang'),

  /// 성북구
  Seongbuk('성북구', 'Seongbuk'),

  /// 강북구
  Gangbuk('강북구', 'Gangbuk'),

  /// 도봉구
  Dobong('도봉구', 'Dobong'),

  /// 노원구
  Nowon('노원구', 'Nowon'),

  /// 은평구
  Eunpyeong('은평구', 'Eunpyeong'),

  /// 서대문구
  Seodaemun('서대문구', 'Seodaemun'),

  /// 마포구
  Mapo('마포구', 'Mapo'),

  /// 양천구
  Yangcheon('양천구', 'Yangcheon'),

  /// 강서구
  Gangseo('강서구', 'Gangseo'),

  /// 구로구
  Guro('구로구', 'Guro'),

  /// 금천구
  Geumcheon('금천구', 'Geumcheon'),

  /// 영등포구
  Yeongdeungpo('영등포구', 'Yeongdeungpo'),

  /// 동작구
  Dongjak('동작구', 'Dongjak'),

  /// 관악구
  Gwanak('관악구', 'Gwanak'),

  /// 서초구
  Seocho('서초구', 'Seocho'),

  /// 강남구
  Gangnam('강남구', 'Gangnam'),

  /// 송파구
  Songpa('송파구', 'Songpa'),

  /// 강동구
  Gangdong('강동구', 'Gangdong');

  // 한글 및 영어 문자열 값
  final String koreanName;
  final String englishName;
  const RegionSeoul(this.koreanName, this.englishName);

  @override
  String toString() => koreanName;

  // 대문자 카멜케이스로 영어 문자열 반환 함수
  String toEngString() => englishName;

  static RegionSeoul? fromKoreanString(String label) {
    for (var value in RegionSeoul.values) {
      if (value.koreanName == label) {
        return value;
      }
    }
    return null;
  }

}

/// 서울 전지역
const String seoulAll = "SeoulAll";
