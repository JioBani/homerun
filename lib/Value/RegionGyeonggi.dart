/// 경기도의 각 행정구역을 나타내는 열거형 (RegionGyeonggiValue)
enum RegionGyeonggi {
  /// 가평·양평
  GapyeongYangpyeong('가평·양평', 'GapyeongYangpyeong'),

  /// 광명·시흥
  GwangmyeongSiheung('광명·시흥', 'GwangmyeongSiheung'),

  /// 부천
  Bucheon('부천', 'Bucheon'),

  /// 양주·연천·포천
  YangjuYeoncheonPocheon('양주·연천·포천', 'YangjuYeoncheonPocheon'),

  /// 용인·광주
  YonginGwangju('용인·광주', 'YonginGwangju'),

  /// 파주
  Paju('파주', 'Paju'),

  /// 화성·오산
  HwaseongOsan('화성·오산', 'HwaseongOsan'),

  /// 과천
  Gwacheon('과천', 'Gwacheon'),

  /// 김포
  Gimpo('김포', 'Gimpo'),

  /// 안양·군포·의왕
  AnyangGunpoUiwang('안양·군포·의왕', 'AnyangGunpoUiwang'),

  /// 여주·이천
  YeojuIcheon('여주·이천', 'YeojuIcheon'),

  /// 성남
  Seongnam('성남', 'Seongnam'),

  /// 평택·안성
  PyeongtaekAnseong('평택·안성', 'PyeongtaekAnseong'),

  /// 고양
  Goyang('고양', 'Goyang'),

  /// 남양주·구리
  NamyangjuGuri('남양주·구리', 'NamyangjuGuri'),

  /// 안산
  Ansan('안산', 'Ansan'),

  /// 의정부·동두천
  UijeongbuDongducheon('의정부·동두천', 'UijeongbuDongducheon'),

  /// 수원
  Suwon('수원', 'Suwon'),

  /// 하남
  Hanam('하남', 'Hanam');

  // 한글 및 영어 문자열 값
  final String koreanName;
  final String englishName;
  const RegionGyeonggi(this.koreanName, this.englishName);

  @override
  String toString() => koreanName;

  // 대문자 카멜케이스로 영어 문자열 반환 함수
  String toEngString() => englishName;

  static RegionGyeonggi? fromKoreanString(String label) {
    for (var value in RegionGyeonggi.values) {
      if (value.koreanName == label) {
        return value;
      }
    }
    return null;
  }

}

/// 서울 전지역
const String gyeonggiAll = "GyeonggiAll";