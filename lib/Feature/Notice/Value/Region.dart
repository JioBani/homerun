enum Region {
  seoul('서울', 'Seoul'),
  gyeonggi('경기', 'Gyeonggi'),
  incheon('인천', 'Incheon'),
  busan('부산', 'Busan'),
  daegu('대구', 'Daegu'),
  gwangju('광주', 'Gwangju'),
  daejeon_sejong('대전·세종', 'DaejeonSejong'),
  ulsan('울산', 'Ulsan'),
  gangwon('강원', 'Gangwon'),
  chungbuk_chungnam('충북·충남', 'ChungbukChungnam'),
  jeonbuk_jeonnam('전북·전남', 'JeonbukJeonnam'),
  gyeongbuk_gyeongnam('경북·경남', 'GyeongbukGyeongnam'),
  jeju('제주', 'Jeju');

  final String koreanString;
  final String englisString;

  const Region(this.koreanString, this.englisString);

  static Region? fromKoreanString(String label) {
    for (var value in Region.values) {
      if (value.koreanString == label) {
        return value;
      }
    }
    return null;
  }

  static List<Region> withoutSeoulGyeonggi(){
    return Region.values.where((region) => region != Region.seoul && region != Region.gyeonggi).toList();
  }

  @override
  String toString() => koreanString;

  // 대문자 카멜케이스로 영어 문자열 반환 함수
  String toEngString() => englisString;
}
